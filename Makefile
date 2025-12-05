javarun:
	@if [ -z "$(arg)" ]; then echo "Usage: make javarun arg=ClassName"; exit 1; fi
	javac solutions/day5_java/day5_$(arg).java
	java solutions.day5_java.day5_$(arg)

benchmark:
	@if [ -z "$(arg)" ]; then echo "Usage: make benchmark arg=ClassName"; exit 1; fi
	for i in {1..20}; do java solutions.day5_java.day5_$(arg); done