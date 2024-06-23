module Heuristics

using Graphs

export greedy_min_degree, greedy_min_fill, greedy_max_card


function greedy_min_degree(graph::SimpleGraph)
    ordering = []
    n = nv(graph)

    neigh = []
    for u in vertices(graph)
        ne = neighbors(graph, u)
        push!(neigh, [length(ne), u, ne])
    end
    # println(neigh)
    # println()

    for v in 1:n
        sort!(neigh)

        u = popfirst!(neigh)
        # println(u)

        push!(ordering, u[2])
        neig = filter(x -> x[2] in u[3], neigh)
        filter!(x -> !(x[2] in u[3]), neigh)

        for ne in neig
            # ne2 = filter(x -> x[2] == ne, neigh)
            not_ne = filter!(x -> x != ne[2], setdiff(u[3], ne[3]))

            new_ne = [ne[1] - 1 + length(not_ne), ne[2], union(not_ne, filter!(x -> x != u[2], ne[3]))]

            push!(neigh, new_ne)
        end

        # println(neigh)

        # println()

    end

    println(ordering)
    return ordering

end


function fill_in(neigh)
    new_neigh = []

    for v in neigh
        ne = filter(x -> x[2] in v[3], neigh)

        num = 0
        for u in ne
            num += length(setdiff(v[3], u[3])) - 1
        end

        push!(new_neigh, [num / 2, v[2], v[3]])
    end

    return new_neigh
end

function greedy_min_fill(graph::SimpleGraph)
    ordering = []
    n = nv(graph)

    neigh = []
    for u in vertices(graph)
        ne = neighbors(graph, u)
        push!(neigh, [length(ne), u, ne])
    end

    neigh = fill_in(neigh)
    # println(neigh)
    # println()

    for v in 1:n
        sort!(neigh)

        u = popfirst!(neigh)
        # println(u)

        push!(ordering, u[2])
        neig = filter(x -> x[2] in u[3], neigh)
        filter!(x -> !(x[2] in u[3]), neigh)
        neigh2 = []

        for ne in neig
            not_ne = filter!(x -> x != ne[2], setdiff(u[3], ne[3]))

            new_ne = [0, ne[2], union(not_ne, filter!(x -> x != u[2], ne[3]))]

            push!(neigh2, new_ne)
        end

        neigh2 = fill_in(neigh2)
        append!(neigh, neigh2)

        # println(neigh)

        # println()

    end

    println(ordering)
    return ordering

end


function greedy_max_card(graph::SimpleGraph)
    ordering = []
    n = nv(graph)

    neigh = []
    for u in vertices(graph)
        ne = neighbors(graph, u)
        push!(neigh, [0, u, ne])
    end

    # println(neigh)
    # println()

    for v in 1:n
        sort!(neigh)

        u = pop!(neigh)
        # println(u)

        pushfirst!(ordering, u[2])

        neig = filter(x -> x[2] in u[3], neigh)
        filter!(x -> !(x[2] in u[3]), neigh)

        for ne in neig
            not_ne = filter!(x -> x != ne[2], setdiff(u[3], ne[3]))

            new_ne = [ne[1] + 1, ne[2], union(not_ne, filter!(x -> x != u[2], ne[3]))]

            push!(neigh, new_ne)
        end


        # println(neigh)

        # println()

    end

    println(ordering)
    return ordering

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

    # greedy_min_degree(graph)
    # greedy_min_fill(graph)
    greedy_max_card(graph)

    # println(length(intersect([5], [1, 2, 5])))
end

# main()

end