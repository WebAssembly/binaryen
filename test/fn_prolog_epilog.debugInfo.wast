(module
  ;;@ src.cpp:1:1
  (func
    (nop)
    ;;@ src.cpp:2:1
    (block $l0
      ;;@ src.cpp:2:2
      (block $l1
        (br $l1)
      )
    )
    ;;@ src.cpp:3:1
    (return)
    ;;@ src.cpp:3:2
  )
)
