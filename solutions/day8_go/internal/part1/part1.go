package part1

import (
	"fmt"
	"io"
	"log"
	"math"
	"os"
	"sort"
	"strconv"
	"strings"
	"time"
)

type Coordinate struct {
	X, Y, Z int
}

type Edge struct {
	I, J     int // indices of the two points
	Distance int // distance between the two points
}

type UnionFind struct {
	Parent []int
	Size   []int
}

func NewUnionFind(n int) *UnionFind {
	uf := &UnionFind{
		Parent: make([]int, n),
		Size:   make([]int, n),
	}
	for i := range n {
		uf.Parent[i] = i
		uf.Size[i] = 1
	}
	return uf
}

func (uf *UnionFind) Find(x int) int {
	if uf.Parent[x] != x {
		uf.Parent[x] = uf.Find(uf.Parent[x])
	}
	return uf.Parent[x]
}

func (uf *UnionFind) Union(x, y int) bool {
	rootX := uf.Find(x)
	rootY := uf.Find(y)
	if rootX == rootY {
		return false
	}
	if uf.Size[rootX] < uf.Size[rootY] {
		uf.Parent[rootX] = rootY
		uf.Size[rootY] += uf.Size[rootX]
	} else {
		uf.Parent[rootY] = rootX
		uf.Size[rootX] += uf.Size[rootY]
	}
	return true
}

func Part1() {
	start := time.Now()

	coordinates := readFileAndSplit("data/day8/day8.txt")
	edges := make([]Edge, 0, len(coordinates)*(len(coordinates)-1)/2) // n(n-1)/2 edges => 1000 * 999 / 2 = 499500 edges for 1000 point input

	for i := range len(coordinates) {
		for j := i + 1; j < len(coordinates); j++ {
			dx := coordinates[i].X - coordinates[j].X
			dy := coordinates[i].Y - coordinates[j].Y
			dz := coordinates[i].Z - coordinates[j].Z
			dist := math.Sqrt(float64(dx*dx + dy*dy + dz*dz))
			edges = append(edges, Edge{I: i, J: j, Distance: int(dist)})
		}
	}
	sort.Slice(edges, func(i, j int) bool {
		return edges[i].Distance < edges[j].Distance
	})
	uf := NewUnionFind(len(coordinates))

	// determine how many edges to process
	maxAttempts := 10 // for test data
	if len(coordinates) == 1000 {
		maxAttempts = 1000
	}

	// process the N shortest edges
	for i := 0; i < maxAttempts && i < len(edges); i++ {
		uf.Union(edges[i].I, edges[i].J)
	}

	// find three largest circuit sizes
	sizes := make(map[int]int)
	for i := range coordinates {
		root := uf.Find(i)
		sizes[root]++
	}

	// get all unique sizes and sort them
	uniqueSizes := make([]int, 0, len(sizes))
	for _, size := range sizes {
		uniqueSizes = append(uniqueSizes, size)
	}
	sort.Sort(sort.Reverse(sort.IntSlice(uniqueSizes)))

	answer := uniqueSizes[0] * uniqueSizes[1] * uniqueSizes[2]

	elapsed := time.Since(start)
	fmt.Printf("Time taken: %v ms (%v µs)\n", elapsed.Milliseconds(), elapsed.Microseconds())
	fmt.Println(answer)
}

func readFileAndSplit(filename string) []Coordinate {
	var coordinates []Coordinate
	file, err := os.Open(filename)
	if err != nil {
		log.Fatalf("Failed to open file: %v", err)
	}
	defer file.Close()

	content, err := io.ReadAll(file)
	if err != nil {
		log.Fatalf("Failed to read file: %v", err)
	}

	lines := strings.SplitSeq(string(content), "\n")
	for line := range lines {
		parts := strings.Split(line, ",")
		x, err := strconv.Atoi(parts[0])
		if err != nil {
			log.Fatalf("Failed to convert string to int: %v", err)
		}

		y, err := strconv.Atoi(parts[1])
		if err != nil {
			log.Fatalf("Failed to convert string to int: %v", err)
		}

		z, err := strconv.Atoi(parts[2])
		if err != nil {
			log.Fatalf("Failed to convert string to int: %v", err)
		}
		coordinates = append(coordinates, Coordinate{X: x, Y: y, Z: z})
	}
	return coordinates
}
