package part2

import (
	"container/heap"
	"fmt"
	"io"
	"log"
	"math"
	"os"
	"strconv"
	"strings"
	"time"
)

type Coordinate struct {
	X, Y, Z int
}

type Edge struct {
	I, J     int
	Distance int
}

type UnionFind struct {
	Parent []int
	Size   []int
}

type EdgeHeap []Edge

func (h EdgeHeap) Len() int           { return len(h) }
func (h EdgeHeap) Less(i, j int) bool { return h[i].Distance < h[j].Distance }
func (h EdgeHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
func (h *EdgeHeap) Push(x any)        { *h = append(*h, x.(Edge)) }
func (h *EdgeHeap) Pop() any { // pop removes and returns the smallest element (shortest edge) from the heap
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[:n-1]
	return x
}

func NewUnionFind(n int) *UnionFind {
	uf := &UnionFind{
		Parent: make([]int, n),
		Size:   make([]int, n),
	}
	for i := range uf.Parent {
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

func Part2() {
	start := time.Now()

	coordinates := readFileAndSplit("data/day8/day8.txt")

	edges := make([]Edge, 0, len(coordinates)*(len(coordinates)-1)/2)
	for i := range len(coordinates) {
		for j := i + 1; j < len(coordinates); j++ {
			dx := coordinates[i].X - coordinates[j].X
			dy := coordinates[i].Y - coordinates[j].Y
			dz := coordinates[i].Z - coordinates[j].Z
			dist := int(math.Sqrt(float64(dx*dx + dy*dy + dz*dz)))
			edges = append(edges, Edge{I: i, J: j, Distance: dist})
		}
	}

	uf := NewUnionFind(len(coordinates))
	numCircuits := len(coordinates) // start with each point in its own circuit

	// heapify all edges
	h := EdgeHeap(edges)
	heap.Init(&h)

	// process edges until we have only 1 circuit
	var lastEdge Edge
	for numCircuits > 1 {
		edge := heap.Pop(&h).(Edge)

		if uf.Union(edge.I, edge.J) {
			// successful merge, reduce circuit count
			numCircuits--   // this is faster than counting all the circuits after each merge
			lastEdge = edge // track the last successful connection
		}
	}

	// calculate answer: multiply X coordinates of the last edge
	xCoord1 := coordinates[lastEdge.I].X
	xCoord2 := coordinates[lastEdge.J].X
	answer := xCoord1 * xCoord2

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
		x, _ := strconv.Atoi(parts[0])
		y, _ := strconv.Atoi(parts[1])
		z, _ := strconv.Atoi(parts[2])
		coordinates = append(coordinates, Coordinate{X: x, Y: y, Z: z})
	}
	return coordinates
}
