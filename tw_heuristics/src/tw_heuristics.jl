module TwHeuristics

include("load_data.jl")
using .LoadData
include("heuristics.jl")
using .Heuristics
include("decomposition.jl")
using .Decomposition
include("results.jl")
using .Results
include("statistics.jl")
using .Statistics

using Graphs
using DataFrames
using CSV
using Dates
using ArgParse


function load_one(timestamp, file, folder::AbstractString="../output/generated/", method::AbstractArray=[1, 2, 3])
    cd(@__DIR__)
    # print(file)
    output_folder = replace(folder, "generated" => "results/" * timestamp * "/")
    file_name = chop(file, tail=4)
    graph = read_graph(folder * file)
    # println(graph)    

    neigh = []
    for u in vertices(graph)
        ne = neighbors(graph, u)
        push!(neigh, [u, ne])
    end

    if 1 in method
        ordering_gmd = greedy_min_degree(graph)
        # println(ordering_gmd)
        T_gmd, x_gmd = decomposition_from_ordering(deepcopy(neigh), ordering_gmd)
        save_result(T_gmd, x_gmd, "result_" * file_name * ".csv", output_folder * "gmd/")
    end
    if 2 in method
        ordering_gmf = greedy_min_fill(graph)
        # println(ordering_gmf)
        T_gmf, x_gmf = decomposition_from_ordering(deepcopy(neigh), ordering_gmf)
        save_result(T_gmf, x_gmf, "result_" * file_name * ".csv", output_folder * "gmf/")
    end
    if 3 in method
        ordering_gmc = greedy_max_card(graph)
        # println(ordering_gmc)
        T_gmc, x_gmc = decomposition_from_ordering(deepcopy(neigh), ordering_gmc)
        save_result(T_gmc, x_gmc, "result_" * file_name * ".csv", output_folder * "gmc/")
    end

    # println("\t\tdone")

end


function load_all(folder::AbstractString="../output/generated/", method::AbstractArray=[1, 2, 3], timestamp::AbstractString=Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM"))
    cd(@__DIR__)
    print("Method: " * string(method) * "...............................")
    file_list = readdir(folder)

    start = Dates.now()

    for file in file_list
        load_one(timestamp, file, folder, method)
    end

    duration = Dates.now() - start
    println(duration)

    # duration_folder = "../output/results/" * timestamp * "/"
    duration_folder = replace(folder, "generated" => "results/" * timestamp * "/")
    duration_file = ""
    if method[1] == 1
        duration_file = duration_folder * "gmd.txt"
    end
    if method[1] == 2
        duration_file = duration_folder * "gmf.txt"
    end
    if method[1] == 3
        duration_file = duration_folder * "gmc.txt"
    end

    open(duration_file, "w") do io
        println(io, duration)
    end

end


function load_run_save_statistics(folder::AbstractString, timestamp, methods)
    # result_folder = "../output/results/" * timestamp * "/"
    result_folder = replace(folder, "generated" => "results/" * timestamp * "/")
    println("Working in : " * folder)

    for method in methods
        # call load_all
        load_all(folder, [method], timestamp)

        # call read_results
        get_statistics_for_method(result_folder, method)
    end

end


function main_old()

    start = Dates.now()
    timestamp = Dates.format(start, "yyyy-mm-dd_HH-MM")

    folder = "../output/generated_small/"
    # folder = "../output/generated_big/"
    # folder = "../output/generated/"
    # method = [1]
    method = [1, 2, 3]

    # load_all(folder, method, timestamp)

    folder = "../output/generated/1000/075/"
    methods = [3]
    load_run_save_statistics(folder, timestamp, methods)

    # folders = ["../output/generated/10/", "../output/generated/100/", "../output/generated/1000/025/", "../output/generated/1000/05/", "../output/generated/1000/075/"]
    folders = ["../output/generated/1000/025/", "../output/generated/1000/05/", "../output/generated/1000/075/"]
    # folders = ["../output/generated/200/025/", "../output/generated/200/05/", "../output/generated/200/075/"]
    methods = [1]
    for folder in folders
        # load_run_save_statistics(folder, timestamp, methods)
    end

    println("works")

end


function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--folder", "-f"
        help = "source folder name in folder \"../ouput/generated/\""
        arg_type = AbstractString
        default = ""
        "--method", "-m"
        help = "method for finding elimination ordering (1 = gmd, 2 = gmf, 3 = gmc, 0 = all three)"
        arg_type = Int
        default = 0

    end

    return parse_args(s)
end


function main()
    parsed_args = parse_commandline()
    println("Parsed args:")
    # for (arg, val) in parsed_args
    #     println("  $arg  =>  $val")
    # end

    folder = "../output/generated/" * parsed_args["folder"]
    m = parsed_args["method"]

    if length(parsed_args["folder"]) > 0
        folder *= "/"
    end
    if m == 0
        methods = [1, 2, 3]
    else
        methods = [m]
    end

    # println(folder)
    # println(methods)

    start = Dates.now()
    timestamp = Dates.format(start, "yyyy-mm-dd_HH-MM")

    load_run_save_statistics(folder, timestamp, methods)
end


# main_old()
main()

end
