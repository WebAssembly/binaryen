(module
 (func $0 (result f64)
  (if
   (i32.const 0)
   (loop $label$2
    (unreachable)
   )
  )
  (f64.const -nan:0xfffffd63e4e5a)
 )
)
(module
 (func $0 (result i32)
  (block $label$8
   (block $label$9
    (block $label$16
     (block $label$18
      (block $label$19
       (br_table $label$18 $label$16 $label$19
        (i32.const 0)
       )
      )
      (br_table $label$9 $label$8
       (i32.const 1)
      )
     )
     (unreachable)
    )
    (unreachable)
   )
   (unreachable)
  )
  (i32.const 2)
 )
)
(module
  (func $br-to-unreachable
    (block $a
      (block $b
        (block $c
          (br $b)
          (br $b)
        )
        (br $b)
        (nop)
      )
      (unreachable)
    )
  )
  (func $many-br-to-unreachable (param $x i32) (result i32)
    (block $label$1
     (block $label$2
      (block $label$3
       (block $label$4
        (block $label$5
         (block $label$6
          (block $label$7
           (block $label$8
            (block $label$9
             (block $label$10
              (block $label$11
               (block $label$12
                (block $label$13
                 (block $label$14
                  (block $label$15
                   (block $label$16
                    (block $label$17
                     (block $label$18
                      (block $label$19
                       (block $label$20
                        (block $label$21
                         (block $label$22
                          (block $label$23
                           (block $label$24
                            (block $label$25
                             (block $label$26
                              (block $label$27
                               (block $label$28
                                (block $label$29
                                 (block $label$30
                                  (block $label$31
                                   (block $label$32
                                    (block $label$33
                                     (block $label$34
                                      (block $label$35
                                       (block $label$36
                                        (block $label$37
                                         (block $label$38
                                          (block $label$39
                                           (block $label$40
                                            (block $label$41
                                             (block $label$42
                                              (block $label$43
                                               (block $label$44
                                                (block $label$45
                                                 (block $label$46
                                                  (block $label$47
                                                   (block $label$48
                                                    (block $label$49
                                                     (block $label$50
                                                      (block $label$51
                                                       (block $label$52
                                                        (block $label$53
                                                         (block $label$54
                                                          (block $label$55
                                                           (block $label$56
                                                            (block $label$57
                                                             (block $label$58
                                                              (block $label$59
                                                               (block $label$60
                                                                (block $label$61
                                                                 (block $label$62
                                                                  (block $label$63
                                                                   (br_table $label$17 $label$17 $label$17 $label$18 $label$19 $label$21 $label$22 $label$22 $label$23 $label$23 $label$23 $label$23 $label$23 $label$23 $label$24 $label$24 $label$25 $label$25 $label$25 $label$26 $label$26 $label$27 $label$27 $label$28 $label$29 $label$29 $label$29 $label$29 $label$29 $label$30 $label$32 $label$33 $label$34 $label$35 $label$35 $label$36 $label$36 $label$36 $label$37 $label$37 $label$37 $label$38 $label$39 $label$40 $label$40 $label$41 $label$41 $label$43 $label$43 $label$43 $label$44 $label$44 $label$45 $label$45 $label$46 $label$47 $label$47 $label$48 $label$49 $label$50 $label$50 $label$51 $label$52 $label$54 $label$54 $label$54 $label$55 $label$56 $label$57 $label$57 $label$57 $label$57 $label$58 $label$58 $label$58 $label$58 $label$58 $label$59 $label$59 $label$59 $label$59 $label$59 $label$60 $label$61 $label$62 $label$62 $label$62 $label$63 $label$13 $label$13 $label$14 $label$14 $label$15 $label$15 $label$15 $label$15 $label$15 $label$16 $label$16 $label$20 $label$31 $label$31 $label$31 $label$42 $label$53 $label$53 $label$12
                                                                    (get_local $x)
                                                                   )
                                                                  )
                                                                  (br $label$1)
                                                                 )
                                                                 (br $label$1)
                                                                )
                                                                (br $label$1)
                                                               )
                                                               (br $label$1)
                                                              )
                                                              (br $label$1)
                                                             )
                                                             (br $label$1)
                                                            )
                                                            (br $label$1)
                                                           )
                                                           (br $label$2)
                                                          )
                                                          (br $label$2)
                                                         )
                                                         (br $label$2)
                                                        )
                                                        (br $label$3)
                                                       )
                                                       (br $label$2)
                                                      )
                                                      (br $label$2)
                                                     )
                                                     (br $label$2)
                                                    )
                                                    (br $label$11)
                                                   )
                                                   (br $label$11)
                                                  )
                                                  (br $label$10)
                                                 )
                                                 (br $label$10)
                                                )
                                                (br $label$9)
                                               )
                                               (br $label$9)
                                              )
                                              (unreachable)
                                             )
                                             (br $label$3)
                                            )
                                            (unreachable)
                                           )
                                           (unreachable)
                                          )
                                          (unreachable)
                                         )
                                         (unreachable)
                                        )
                                        (unreachable)
                                       )
                                       (br $label$8)
                                      )
                                      (br $label$8)
                                     )
                                     (br $label$7)
                                    )
                                    (br $label$7)
                                   )
                                   (unreachable)
                                  )
                                  (br $label$3)
                                 )
                                 (br $label$4)
                                )
                                (br $label$4)
                               )
                               (br $label$4)
                              )
                              (unreachable)
                             )
                             (unreachable)
                            )
                            (unreachable)
                           )
                           (unreachable)
                          )
                          (br $label$6)
                         )
                         (br $label$6)
                        )
                        (unreachable)
                       )
                       (br $label$3)
                      )
                      (unreachable)
                     )
                     (unreachable)
                    )
                    (unreachable)
                   )
                   (br $label$3)
                  )
                  (br $label$5)
                 )
                 (br $label$5)
                )
                (br $label$5)
               )
               (unreachable)
              )
              (unreachable)
             )
             (unreachable)
            )
            (unreachable)
           )
           (unreachable)
          )
          (unreachable)
         )
         (unreachable)
        )
        (unreachable)
       )
       (unreachable)
      )
      (unreachable)
     )
     (unreachable)
    )
    (unreachable)
  )
  (func $br-to-return_b
    (block $a
      (block $b
        (block $c
          (br $b)
          (br $b)
        )
        (br $b)
        (nop)
      )
      (return)
    )
  )
  (func $many-br-to-return_b (param $x i32)
    (block $label$1
     (block $label$2
      (block $label$3
       (block $label$4
        (block $label$5
         (block $label$6
          (block $label$7
           (block $label$8
            (block $label$9
             (block $label$10
              (block $label$11
               (block $label$12
                (block $label$13
                 (block $label$14
                  (block $label$15
                   (block $label$16
                    (block $label$17
                     (block $label$18
                      (block $label$19
                       (block $label$20
                        (block $label$21
                         (block $label$22
                          (block $label$23
                           (block $label$24
                            (block $label$25
                             (block $label$26
                              (block $label$27
                               (block $label$28
                                (block $label$29
                                 (block $label$30
                                  (block $label$31
                                   (block $label$32
                                    (block $label$33
                                     (block $label$34
                                      (block $label$35
                                       (block $label$36
                                        (block $label$37
                                         (block $label$38
                                          (block $label$39
                                           (block $label$40
                                            (block $label$41
                                             (block $label$42
                                              (block $label$43
                                               (block $label$44
                                                (block $label$45
                                                 (block $label$46
                                                  (block $label$47
                                                   (block $label$48
                                                    (block $label$49
                                                     (block $label$50
                                                      (block $label$51
                                                       (block $label$52
                                                        (block $label$53
                                                         (block $label$54
                                                          (block $label$55
                                                           (block $label$56
                                                            (block $label$57
                                                             (block $label$58
                                                              (block $label$59
                                                               (block $label$60
                                                                (block $label$61
                                                                 (block $label$62
                                                                  (block $label$63
                                                                   (br_table $label$17 $label$17 $label$17 $label$18 $label$19 $label$21 $label$22 $label$22 $label$23 $label$23 $label$23 $label$23 $label$23 $label$23 $label$24 $label$24 $label$25 $label$25 $label$25 $label$26 $label$26 $label$27 $label$27 $label$28 $label$29 $label$29 $label$29 $label$29 $label$29 $label$30 $label$32 $label$33 $label$34 $label$35 $label$35 $label$36 $label$36 $label$36 $label$37 $label$37 $label$37 $label$38 $label$39 $label$40 $label$40 $label$41 $label$41 $label$43 $label$43 $label$43 $label$44 $label$44 $label$45 $label$45 $label$46 $label$47 $label$47 $label$48 $label$49 $label$50 $label$50 $label$51 $label$52 $label$54 $label$54 $label$54 $label$55 $label$56 $label$57 $label$57 $label$57 $label$57 $label$58 $label$58 $label$58 $label$58 $label$58 $label$59 $label$59 $label$59 $label$59 $label$59 $label$60 $label$61 $label$62 $label$62 $label$62 $label$63 $label$13 $label$13 $label$14 $label$14 $label$15 $label$15 $label$15 $label$15 $label$15 $label$16 $label$16 $label$20 $label$31 $label$31 $label$31 $label$42 $label$53 $label$53 $label$12
                                                                    (get_local $x)
                                                                   )
                                                                  )
                                                                  (br $label$1)
                                                                 )
                                                                 (br $label$1)
                                                                )
                                                                (br $label$1)
                                                               )
                                                               (br $label$1)
                                                              )
                                                              (br $label$1)
                                                             )
                                                             (br $label$1)
                                                            )
                                                            (br $label$1)
                                                           )
                                                           (br $label$2)
                                                          )
                                                          (br $label$2)
                                                         )
                                                         (br $label$2)
                                                        )
                                                        (br $label$3)
                                                       )
                                                       (br $label$2)
                                                      )
                                                      (br $label$2)
                                                     )
                                                     (br $label$2)
                                                    )
                                                    (br $label$11)
                                                   )
                                                   (br $label$11)
                                                  )
                                                  (br $label$10)
                                                 )
                                                 (br $label$10)
                                                )
                                                (br $label$9)
                                               )
                                               (br $label$9)
                                              )
                                              (return)
                                             )
                                             (br $label$3)
                                            )
                                            (return)
                                           )
                                           (return)
                                          )
                                          (return)
                                         )
                                         (return)
                                        )
                                        (return)
                                       )
                                       (br $label$8)
                                      )
                                      (br $label$8)
                                     )
                                     (br $label$7)
                                    )
                                    (br $label$7)
                                   )
                                   (return)
                                  )
                                  (br $label$3)
                                 )
                                 (br $label$4)
                                )
                                (br $label$4)
                               )
                               (br $label$4)
                              )
                              (return)
                             )
                             (return)
                            )
                            (return)
                           )
                           (return)
                          )
                          (br $label$6)
                         )
                         (br $label$6)
                        )
                        (return)
                       )
                       (br $label$3)
                      )
                      (return)
                     )
                     (return)
                    )
                    (return)
                   )
                   (br $label$3)
                  )
                  (br $label$5)
                 )
                 (br $label$5)
                )
                (br $label$5)
               )
               (return)
              )
              (return)
             )
             (return)
            )
            (return)
           )
           (return)
          )
          (return)
         )
         (return)
        )
        (return)
       )
       (return)
      )
      (return)
     )
     (return)
    )
    (return)
  )
)
