javarun:
	@if [ -z "$(arg)" ]; then echo "Usage: make javarun arg=ClassName"; exit 1; fi
	javac solutions/day5_java/day5_$(arg).java
	java solutions.day5_java.day5_$(arg)

javabench:
	@if [ -z "$(arg)" ]; then echo "Usage: make javabench arg=ClassName"; exit 1; fi
	javac solutions/day5_java/day5_$(arg).java
	for i in {1..20}; do java solutions.day5_java.day5_$(arg); done

haskellrun:
	@if [ -z "$(arg)" ]; then echo "Usage: make haskellrun arg=part_name"; exit 1; fi
	ghc solutions/day6_haskell/day6_$(arg).hs -o solutions/day6_haskell/day6_$(arg)
	./solutions/day6_haskell/day6_$(arg)

haskellbench:
	@if [ -z "$(arg)" ]; then echo "Usage: make haskellbench arg=part_name"; exit 1; fi
	ghc solutions/day6_haskell/day6_$(arg).hs -o solutions/day6_haskell/day6_$(arg)
	for i in {1..20}; do ./solutions/day6_haskell/day6_$(arg); done

elixirrun:
	@if [ -z "$(arg)" ]; then echo "Usage: make elixirrun arg=part_name"; exit 1; fi
	elixir solutions/day7_elixir/day7_$(arg).ex

elixirbench:
	@if [ -z "$(arg)" ]; then echo "Usage: make elixirbench arg=part_name"; exit 1; fi
	elixir solutions/day7_elixir/day7_$(arg).ex
	for i in {1..20}; do elixir solutions/day7_elixir/day7_$(arg).ex; done

gorun:
	go run solutions/day8_go/cmd/main.go

gobench:
	go run solutions/day8_go/cmd/main.go
	for i in {1..20}; do go run solutions/day8_go/cmd/main.go; done

csrun:
	@if [ -z "$(arg)" ]; then echo "Usage: make csrun arg=part_name"; exit 1; fi
	dotnet run --project solutions/day9_c#/day9.csproj $(arg)

csbench:
	@if [ -z "$(arg)" ]; then echo "Usage: make csbench arg=part_name"; exit 1; fi
	for i in {1..20}; do dotnet run --project solutions/day9_c#/day9.csproj $(arg); done