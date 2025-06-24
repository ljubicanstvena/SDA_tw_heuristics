module GenerateGraphs

using Graphs
using ArgParse

export generate_graphs


"Saves the graph under a specified name"
function save_graph(graph::SimpleGraph, file_name::String, output_folder::String="../output/generated/")
    cd(@__DIR__)
    # creates output_folder
    mkpath(output_folder)
    file_path = output_folder * file_name

    # deletes the old file if it exists
    if isfile(file_path)
        rm(file_path)
    end

    open(file_path, "w") do io
        # add n as first line
        println(io, string(nv(graph)))

        # every line contains the name of the vertex and the list of neughbors
        for vertex in vertices(graph)
            v = string(vertex)
            for neigh in neighbors(graph, vertex)
                v *= ","
                v *= string(neigh)
            end
            println(io, v)
        end
    end

end

"Generates a single graph with the parameters"
function generate_graph(n, p, num::Int=0, output_folder::String="../output/generated/")
    # generates a graph 
    graph = erdos_renyi(n, p)

    # saves it under the specified name
    save_graph(graph, "graph_" * string(n) * "_" * string(p) * "_" * string(num) * ".csv", output_folder)

end

"Generates multiple graphs"
function generate_graphs(ns::AbstractArray, ps::AbstractArray, number::Int64, output_folder::String="../output/generated/")
    for n in ns
        for p in ps
            for num = 1:number

                generate_graph(n, p, num, output_folder)

            end
        end
    end
end


function main_old()

    # generate_graph(5, 0.5)

    # specified by task
    # ns = [10, 100, 1000]
    ns = [10]
    ps = [0.25, 0.5, 0.75]
    number = 100 
    # number = 3
    # generate_graphs(ns, ps, number, "../output/generated/10/")
    # ns = [100]
    # generate_graphs(ns, ps, number, "../output/generated/100/")
    # ns = [1000]
    # ps = [0.25]
    # number = 10
    # generate_graphs(ns, ps, number, "../output/generated/1000/025/")
    # ns = [1000]
    # ps = [0.5]
    # generate_graphs(ns, ps, number, "../output/generated/1000/05/")
    # ns = [1000]
    # ps = [0.75]
    # generate_graphs(ns, ps, number, "../output/generated/1000/075/")

    ns = [200]
    ps = [0.25]
    generate_graphs(ns, ps, number, "../output/generated/200/025/")
    ps = [0.5]
    generate_graphs(ns, ps, number, "../output/generated/200/05/")
    ps = [0.75]
    generate_graphs(ns, ps, number, "../output/generated/200/075/")

end


function parse_commandline()
    s = ArgParseSettings()
    
    @add_arg_table s begin
        "--nv", "-n"
            help = "number of vertices (0 means all three: 10, 100, and 1000)"
            arg_type = Int
            default = 0
        "--probability", "-p"
            help = "probability (0.0 means all three: 0.25, 0.5, 0.75)"
            arg_type = Float64
            default = 0.0
        "--size", "-s"
            help = "size of dataset"
            arg_type = Int
            default = 100
        "--folder", "-f"
            help = "destination folder name in folder \"../ouput/generated/\""
            arg_type = AbstractString
            default = ""
    
    end

    return parse_args(s)
end


function main()
    parsed_args = parse_commandline()
    # println("Parsed args:")
    # for (arg,val) in parsed_args
    #     println("  $arg  =>  $val")
    # end

    n = parsed_args["nv"]
    p = parsed_args["probability"]
    num = parsed_args["size"]
    f = "../output/generated/" * parsed_args["folder"]

    if n == 0
        n = [10, 100, 1000]
    else
        n = [n]
    end
    if p == 0.0
        p = [0.25, 0.5, 0.75]
    else
        p = [p]
    end
    if length(parsed_args["folder"]) > 0
        f *= "/"
    end

    # println(n)
    # println(p)
    # println(num)
    # println(f)

    generate_graphs(n, p, num, f)
end


# main_old()
main()

end