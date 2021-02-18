extern bool getBoolean();

int main() {
  try {
    throw 0;
  } catch(int) {
    while (getBoolean()) {
      getBoolean();
    }
  }
}
