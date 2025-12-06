javarun:
	@if [ -z "$(arg)" ]; then echo "Usage: make javarun arg=ClassName"; exit 1; fi
	javac solutions/day5_java/day5_$(arg).java
	java solutions.day5_java.day5_$(arg)

javabench:
	@if [ -z "$(arg)" ]; then echo "Usage: make javabench arg=ClassName"; exit 1; fi
	javac solutions/day5_java/day5_$(arg).java
	for i in {1..20}; do java solutions.day5_java.day5_$(arg); done

haskellrun:
	@if [ -z "$(arg)" ]; then echo "Usage: make haskellrun arg=ClassName"; exit 1; fi
	ghc solutions/day6_haskell/day6_$(arg).hs -o solutions/day6_haskell/day6_$(arg)
	./solutions/day6_haskell/day6_$(arg)

haskellbench:
	@if [ -z "$(arg)" ]; then echo "Usage: make haskellbench arg=ClassName"; exit 1; fi
	ghc solutions/day6_haskell/day6_$(arg).hs -o solutions/day6_haskell/day6_$(arg)
	for i in {1..20}; do ./solutions/day6_haskell/day6_$(arg); done