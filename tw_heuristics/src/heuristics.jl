module Heuristics

using Graphs

export greedy_min_degree, greedy_min_fill, greedy_max_card


function greedy_min_degree(graph::SimpleGraph)
    ordering = []
    n = nv(graph)

    # creates a list of vertices(u) and its neighbors(ne) and degrees(length(ne))
    neigh = []
    for u in vertices(graph)
        ne = neighbors(graph, u)
        push!(neigh, [length(ne), u, ne])
    end

    for v in 1:n
        # sorts the list of vertices in ascending order of their degrees
        sort!(neigh)
        # println(neigh)

        # takes the vertex with smallest degree
        u = popfirst!(neigh)
        # println(u)

        # adds vertex to the ordering
        push!(ordering, u[2])
        # takes the neighbors of vertex and removes them from the list
        neig = filter(x -> x[2] in u[3], neigh)
        filter!(x -> !(x[2] in u[3]), neigh)

        # for every neighbor, find the not neighbors and connect them
        for ne in neig
            # ne2 = filter(x -> x[2] == ne, neigh)
            not_ne = filter!(x -> x != ne[2], setdiff(u[3], ne[3]))

            new_ne = [ne[1] - 1 + length(not_ne), ne[2], union(not_ne, filter(x -> x != u[2], ne[3]))]

            push!(neigh, new_ne)
        end

        # println(neigh)
        # println()

    end

    # println(ordering)
    return ordering
end


function fill_in(neigh)
    new_neigh = []

    # for every vertex, compute the number of edges that would need to be filled in between the neighbors
    for v in neigh
        ne = filter(x -> x[2] in v[3], neigh)

        num = 0
        for u in ne
            num += length(setdiff(v[3], u[3])) - 1
        end

        push!(new_neigh, [Int(num / 2), v[2], v[3]])
    end

    return new_neigh
end


function greedy_min_fill(graph::SimpleGraph)
    ordering = []
    n = nv(graph)

    # creates a list of vertices(u) and its neighbors(ne) and degrees(length(ne))
    neigh = []
    for u in vertices(graph)
        ne = neighbors(graph, u)
        push!(neigh, [Int(length(ne)), u, ne])
    end

    # calculates the number of fill in edges for every vertex
    neigh = fill_in(neigh)
    # println(neigh)
    # println()
    
    for v in 1:n
        # sorts the list ascending by number of fill in edges
        sort!(neigh)
        # println(neigh)

        # take the vertex with least fill in edges
        u = popfirst!(neigh)
        # println(u)

        # add vertex to the ordering
        push!(ordering, u[2])
        # take all neighbors of the vertex and remove them from the list
        neig = filter(x -> x[2] in u[3], neigh)
        filter!(x -> !(x[2] in u[3]), neigh)
        neigh2 = []

        # for every neighbor, find the not neighbors and connect them
        for ne in neig
            not_ne = filter!(x -> x != ne[2], setdiff(u[3], ne[3]))

            new_ne = [0, ne[2], union(not_ne, filter(x -> x != u[2], ne[3]))]

            push!(neigh2, new_ne)
        end

        # add the new neighbors and repeat the calculation of fill in edges
        append!(neigh, neigh2)
        neigh = fill_in(neigh)

        # println(neigh)
        # println()

    end

    # println(ordering)
    return ordering

end


function greedy_max_card(graph::SimpleGraph)
    ordering = []
    n = nv(graph)
    
    # creates a list of vertices(u) and its neighbors(ne) and number of neighbors already in the elimination ordering
    neigh = []
    for u in vertices(graph)
        ne = neighbors(graph, u)
        push!(neigh, [0, u, ne])
    end

    # println(neigh)
    # println()

    for v in 1:n
        # sorts the list in ascending order of vertices already in the elimination ordering
        sort!(neigh)
        # println(neigh)
        # println()

        # takes the vertex with most neighbors in the ordering
        u = pop!(neigh)
        # println(u)

        # adds the vertex to the ordering
        push!(ordering, u[2])

        # filters its neighbors
        neig = filter(x -> x[2] in u[3], neigh)
        filter!(x -> !(x[2] in u[3]), neigh)

        # for every neighbor, increase the num of neigh in el ord by 1
        for ne in neig
            new_ne = [ne[1] + 1, ne[2], filter(x -> x != u[2], ne[3])]

            push!(neigh, new_ne)
        end

        # println(neigh)
        # println()

    end

    # println(ordering)
    return ordering

end


function main()

    graph = SimpleGraph(5)
    add_edge!(graph, 1, 2)
    add_edge!(graph, 1, 3)
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