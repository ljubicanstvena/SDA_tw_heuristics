module TwHeuristics

include("load_data.jl")
using .LoadData
include("heuristics.jl")
using .Heuristics
include("decomposition.jl")
using .Decomposition
include("results.jl")
using .Results

using Graphs
using DataFrames
using CSV


function calculate_tw(T, x)
    tw = length(x[1][2]) - 1
    for bag in x
        l = length(bag[2])
        if l > tw
            tw = l
        end
    end
    return tw
end

function load_all()
    cd(@__DIR__)
    folder = "../output/generated/"
    file_list = readdir(folder)

    df_gmd = DataFrame(name=String[], n=Int64[], m=Int64[], tw=Int64[])
    df_gmf = DataFrame(name=String[], n=Int64[], m=Int64[], tw=Int64[])
    df_gmc = DataFrame(name=String[], n=Int64[], m=Int64[], tw=Int64[])
    df_total = DataFrame(name=String[], n=Int64[], m=Int64[], tw_gmd=Int64[], tw_gmf=Int64[], tw_gmc=Int64[])

    for file in file_list
        println()
        println()
        println(file)
        file_name = chop(file, tail=4)
        graph = read_graph(folder * file)
        # println(graph)

        ordering_gmd = greedy_min_degree(graph)
        ordering_gmf = greedy_min_fill(graph)
        ordering_gmc = greedy_max_card(graph)

        neigh = []
        for u in vertices(graph)
            ne = neighbors(graph, u)
            push!(neigh, [u, ne])
        end

        T_gmd, x_gmd = decomposition_from_ordering(deepcopy(neigh), ordering_gmd)
        T_gmf, x_gmf = decomposition_from_ordering(deepcopy(neigh), ordering_gmf)
        T_gmc, x_gmc = decomposition_from_ordering(deepcopy(neigh), ordering_gmc)

        save_result(T_gmd, x_gmd, "result_" * file_name * ".txt", "../output/results/gmd/")
        save_result(T_gmf, x_gmf, "result_" * file_name * ".txt", "../output/results/gmf/")
        save_result(T_gmc, x_gmc, "result_" * file_name * ".txt", "../output/results/gmc/")

        tw_gmd = calculate_tw(T_gmd, x_gmd)
        tw_gmf = calculate_tw(T_gmf, x_gmf)
        tw_gmc = calculate_tw(T_gmc, x_gmc)

        push!(df_gmd, [file_name, nv(graph), ne(graph), tw_gmd])
        push!(df_gmf, [file_name, nv(graph), ne(graph), tw_gmf])
        push!(df_gmc, [file_name, nv(graph), ne(graph), tw_gmc])
        push!(df_total, [file_name, nv(graph), ne(graph), tw_gmd, tw_gmf, tw_gmc])

    end

    statistics_folder = "../output/statistics/"
    CSV.write(statistics_folder * "statistics_gmd.csv", df_gmd)
    CSV.write(statistics_folder * "statistics_gmf.csv", df_gmf)
    CSV.write(statistics_folder * "statistics_gmc.csv", df_gmc)
    CSV.write(statistics_folder * "statistics_total.csv", df_total)

end


function main()

    load_all()

end

main()

end
