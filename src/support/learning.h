/*
 * Copyright 2016 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef wasm_learning_h
#define wasm_learning_h

#include <algorithm>
#include <random>

namespace wasm {

//
// Machine learning using a genetic algorithm.
//
// The Genome class is the element on which to learn. It must
// implement the following:
//
//  * Fitness getFitness(); - calculate how good this item is.
//
// The Generator must implement the following:
//
//  * Genome* makeRandom(); - make a random element
//  * Genome* makeMixture(Genome* one, Genome* two); - make a new element by mixing two
//
// Fitness is the type of the fitness values, e.g. uint32_t. More is better.
//
// Typical usage of this class is to run call runGeneration(), check the best
// quality using getBest()->getFitness(), and do that repeatedly until the
// fitness is good enough. Then acquireBest() to get ownership of the best,
// and the learner can be discarded (with all the rest of the population
// cleaned up).

template<typename Genome, typename Fitness, typename Generator>
class GeneticLearner {
  Generator& generator;

  typedef std::unique_ptr<Genome> unique_ptr;
  std::vector<unique_ptr> population;

  void sort() {
    std::sort(population.begin(), population.end(), [](const unique_ptr& left, const unique_ptr& right) {
      return left->getFitness() > right->getFitness();
    });
  }

  std::mt19937 noise;

  size_t randomIndex() {
    return noise() % population.size();
  }

public:
  GeneticLearner(Generator& generator, size_t size) : generator(generator), noise(1337) {
    population.resize(size);
    for (size_t i = 0; i < size; i++) {
      population[i] = unique_ptr(generator.makeRandom());
    }
    sort();
  }

  Genome* getBest() {
    return population[0].get();
  }

  unique_ptr acquireBest() {
    return population[0];
  }

  void runGeneration() {
    size_t size = population.size();

    // we have a mix of promoted from the last generation, mixed from the last generation, and random
    const size_t promoted = (25 * size) / 100;
    const size_t mixed = (50 * size) / 100;

    // promoted just stay in place
    // mixtures are computed, then added back in (as we still need them as we work)
    std::vector<unique_ptr> mixtures;
    mixtures.resize(mixed);
    for (size_t i = 0; i < mixed; i++) {
      mixtures[i] = unique_ptr(generator.makeMixture(population[randomIndex()].get(), population[randomIndex()].get()));
    }
    for (size_t i = 0; i < mixed; i++) {
      population[promoted + i].swap(mixtures[i]);
    }
    // TODO: de-duplicate at this point
    // randoms fill in the test
    for (size_t i = promoted + mixed; i < size; i++) {
      population[i] = unique_ptr(generator.makeRandom());
    }

    sort();
  }
};

}  // namespace wasm

#endif  // wasm_learning_h
