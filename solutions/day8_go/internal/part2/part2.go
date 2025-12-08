package part2

import (
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

func Part2() {
	start := time.Now()

	coords := readFileAndSplit("data/day8/day8.txt")
	n := len(coords)
	if n == 0 {
		fmt.Println("0")
		return
	}

	const inf = int(^uint(0) >> 1) // max int
	inTree := make([]bool, n)
	minDist := make([]int, n)
	parent := make([]int, n)

	for i := range n {
		minDist[i] = inf
		parent[i] = -1
	}

	dist := func(a, b int) int {
		dx := coords[a].X - coords[b].X
		dy := coords[a].Y - coords[b].Y
		dz := coords[a].Z - coords[b].Z
		return int(math.Sqrt(float64(dx*dx + dy*dy + dz*dz)))
	}

	inTree[0] = true
	for i := range n {
		minDist[i] = dist(0, i)
		parent[i] = 0
	}

	maxEdgeW, maxU, maxV := -1, 0, 0

	// add n-1 nodes to the MST (Minimum Spanning Tree)
	for range n - 1 {
		// pick closest node not yet in tree
		v, best := -1, inf
		for i := range n {
			if !inTree[i] && minDist[i] < best {
				best, v = minDist[i], i
			}
		}
		inTree[v] = true

		// update the maximum weight edge in the MST if this one is heavier
		if best > maxEdgeW {
			maxEdgeW = best
			maxU, maxV = parent[v], v
		}

		// update distances for nodes not yet in the tree
		for u := range n {
			if inTree[u] {
				continue
			}
			if d := dist(v, u); d < minDist[u] {
				minDist[u] = d
				parent[u] = v
			}
		}
	}

	answer := coords[maxU].X * coords[maxV].X
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
