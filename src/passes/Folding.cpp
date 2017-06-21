
* we seek things to optimize. we can only optimize
  * things with type none or unreachable [1], as we replace with a branch - we can't replace a value!
  * we can handle an unreachable in a loop body or if arm, or unreachable at the tail of
    a block plus zero or more none preludes (assuming dce happened before, it is truly a tail)
* scan the function, emit this data structure, one bigg array
  * [begin X],...,[end X] for all block, loop, if
  * [thing X, currp* for it (so can replace parent usage)] for all X of type none or unreachable, i.e., potential to merge
    to see if we are potentials, check type and parent (and location in parent in block).
    if on a loop body or if arm, can discard now if not big enough to matter
* we can then prepare to look for stuff to do
  * compute the hash of each potential and using that, make a unique id for each truly unique
    value (hashing just speeds up the computation)
  * end up with a list of those unique ids => vector of the unique items (or rather their index in the bigg array)
* then actually look:
  * for each unique id, see if it has >1 element, and it is unreachable
  * if so, see what we can do here. we want to merge this element + some nones that lead to it
    (note how if the unreachable is on a loop body or if arm, there can't be none preludes, so ok to look for them but we will find none and not be confused)
  * start at zero preludes, then keep going while the preludes match for at least 2, removing ones that do not
    * may have splitting: used to have 4, then adding a prelude split them into 2 and 2  that are both identical. pick one / biggest
    * compute the benefit for that # of preludes: (size of preludes + size of finale) * (number of appearances - 1) - (size of br) * (number of apperances + 1) - 2*size-of-a-block
      this sort of depends on the parent, as an if parent requires another block. maybe compute that here, take into account?
  * hopefully at least one is worth it, if so pick the best
  * great, do a merge:
    * look left from leftmost, look right from rightmost, find the shared parent of them all
      start at leftmost and rightmost, maintain a set of "seen", and keep going, noting
      seen starts on the left and endings on the right (and stopping at array boundary). once we find both a start and an end
      then that is the parent.
      (this must be ok: consider if they have a br to $x, then $x is reachable from all of them,
       and given our uniqueness of br targets, this is good)
    * given the parent, we have this:
      (parent
        ..
        (stuff
          (to-replace 1)
        )
        ..
        (stuff
          (to-replace N)
        )
        ..
      )
    * note that they might branch to the parent!
    * if parent is a block, transform to this:
      (parent
        (merged-code ;; this block is the old parent, reused and renamed
          ..
          (stuff
            (br merged-code)
          )
          ..
          (stuff
            (br merged-code)
          )
          ..
          if the parent had a value flowing out - look at final element - then we must replace the value with (br parent (value))
          if the parent does not have an unreachable element, need to add a (br parent)
        )
        (merged code here) ;; ends in unreachable, so ok to not flow anything
      )
    * parent cannot be a loop, as it has just one child! so there would be another parent
    * if parent is an if, then do this:
      (after-merge
        (merged-code
          (parent
            ..
            (stuff
              (br merged-code)
            )
            ..
            (stuff
              (br merged-code)
            )
            ..
          )
          (br after-merge) ;; or if the if returns a value, use that value in the br, and after-merge will have a value
        )
        (merged code here) ;; ends in unreachable, so ok to not flow anything
      )
    * after we merge, stop and do another pass from the very beginning (or should we update the data structures? merging is rare, so a full do-over is probably ok)

[1] may want to detect call $abort as "unreachable", ie. no-exit

