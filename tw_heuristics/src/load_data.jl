module LoadData

using Graphs


export read_graph


"Reads the graph from the input file specified as the name"
function read_graph(file_path::AbstractString)::SimpleGraph{Int}
    cd(@__DIR__)
    if !endswith(file_path, ".csv") || !isfile(file_path)
        throw(error("Not a file:\t" * file_path))
    end

    graph = SimpleGraph()

    open(file_path) do file

        lines = readlines(file)

        # initialize empty graph
        n = parse(Int, popfirst!(lines))
        graph = SimpleGraph(n)

        # read every row and save information
        for s in lines

            l = [parse(Int, ss) for ss in split(s, ',')]
            u = popfirst!(l)

            for v in l
                add_edge!(graph, u, v)
            end
        end

    end

    # println(graph)
    # println(nv(graph))

    return graph
end


function main()
    file = "graph_5_0.5_1.csv"
    folder = "../output/generated/"
    file_path = folder * file

    read_graph(file_path)

end

# main()

end