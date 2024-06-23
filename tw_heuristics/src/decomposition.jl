module Decomposition

using Graphs

export decomposition_from_ordering


function decomposition_from_ordering(neigh, ordering)
    if length(neigh) == 1
        # TODO return something
        return [[1], []], [[1, [neigh[1][1]]]]
    end

    v = popfirst!(ordering)
    v = pop!(filter(x -> x[1] == v, neigh))
    # println(v)

    filter!(x -> x[1] != v[1], neigh)
    neig = filter(x -> x[1] in v[2], neigh)
    filter!(x -> !(x[1] in v[2]), neigh)
    # println(neig)

    for ne in neig
        not_ne = filter!(x -> x != ne[1], setdiff(v[2], ne[2]))

        new_ne = [ne[1], union(not_ne, filter!(x -> x != v[1], ne[2]))]

        push!(neigh, new_ne)
    end
    # println(neigh)


    T, x = decomposition_from_ordering(neigh, ordering)
    # println("T")
    # println(T)
    # println("x")
    # println(x)


    t = filter(y -> issubset(Set(v[2]), Set(y[2])), x)
    # println("t")
    # println(t)
    t2 = length(T[1]) + 1
    push!(T[1], t2)
    push!(x, [t2, union(v[2], [v[1]])])
    if length(t) > 0
        t = t[1][1]
        push!(T[2], [t, t2])
    end

    return T, x

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

    neigh = []
    for u in vertices(graph)
        ne = neighbors(graph, u)
        push!(neigh, [u, ne])
    end
    println(neigh)
    println()

    T, x = decomposition_from_ordering(neigh, ordering)

    println()
    println()
    println(T)
    println()
    println(x)
end

# main()

end