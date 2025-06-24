module Decomposition

using Graphs

export decomposition_from_ordering


function decomposition_from_ordering(adjacency_list, ordering)
    # if the graph contains only one vertex, return a new tree decomposition consisting only of one node
    if length(adjacency_list) == 1
        return [[1], []], [[1, [adjacency_list[1][1]]]]
    end

    # takes the first vertex from the ordering
    vertex = popfirst!(ordering)
    vertex = pop!(filter(x -> x[1] == vertex, adjacency_list))
    # println(vertex)

    # removes the vertex from the graph and finds its neighbors
    filter!(x -> x[1] != vertex[1], adjacency_list)
    neighbors = filter(x -> x[1] in vertex[2], adjacency_list)
    filter!(x -> !(x[1] in vertex[2]), adjacency_list)
    # println(neighbors)

    # removes vertex from its neighbors and fills in the edges between them
    for v in neighbors
        not_ne = filter!(x -> x != v[1], setdiff(vertex[2], v[2]))

        new_ne = [v[1], union(not_ne, filter!(x -> x != vertex[1], v[2]))]

        push!(adjacency_list, new_ne)
    end
    # println(adjacency_list)

    # recursive call without the vertex
    T, X = decomposition_from_ordering(adjacency_list, ordering)
    # println("T")
    # println(T)
    # println("X")
    # println(X)

    # finds a node which contains all the neighbors of the vertex
    t = filter(y -> issubset(Set(vertex[2]), Set(y[2])), X)
    # println("t")
    # println(t)
    # creates a new node and adds vertex and its neighbors to it, connects it to the previous node
    t2 = length(T[1]) + 1
    push!(T[1], t2)
    push!(X, [t2, union(vertex[2], [vertex[1]])])
    if length(t) > 0
        t = t[1][1]
        push!(T[2], [t, t2])
    end

    return T, X

end


function main()

    graph = SimpleGraph(5)
    add_edge!(graph, 1, 2)
    # add_edge!(graph, 1, 3)
    add_edge!(graph, 2, 4)
    add_edge!(graph, 2, 5)
    add_edge!(graph, 3, 4)
    add_edge!(graph, 3, 5)
    add_edge!(graph, 4, 5)

    ordering = [1, 2, 3, 4, 5]

    adjacency_list = []
    for u in vertices(graph)
        v = neighbors(graph, u)
        push!(adjacency_list, [u, v])
    end
    # println(adjacency_list)
    # println()

    T, X = decomposition_from_ordering(adjacency_list, ordering)

    println()
    println()
    println(T)
    println()
    println(X)
end

# main()

end