module Vizualise

include("load_data.jl")
using .LoadData

using Graphs
using GraphPlot
using Compose
using Cairo
using Dates
using DataFrames
using CSV
using Plots


function vizualise_file(file::AbstractString, folder_name::AbstractString="generated/", output_folder_name::AbstractString="")
    cd(@__DIR__)

    println(file)
    file_name = chop(file, tail=4)
    folder = "../output/" * folder_name
    output_folder = "../output/vizualisation/" * output_folder_name * "/" * folder_name
    mkpath(output_folder)
    graph = read_graph(folder * file)
    println(graph)

    nodelabel = 1:nv(graph)
    # gplothtml(graph, nodelabel=nodelabel)
    draw(PNG(output_folder * file_name * ".png", 16cm, 16cm), gplot(graph, nodelabel=nodelabel))

end


function vizualise_statistics(folder_name::AbstractString="")
    cd(@__DIR__)

    folder = "../output/statistics/" * folder_name * "/"
    output_folder = "../output/vizualisation/" * folder_name * "/"
    mkpath(output_folder)

    files = readdir(folder)

    df = DataFrame(name=String[], n=String[], p=String[], num=String[], tw=Int64[], method=String[])
    for file in files
        # println(file)
        file_path = folder * file
        if !endswith(file_path, ".csv") || !isfile(file_path)
            throw(error("Not a file:\t" * file_path))
        end

        method = chop(file, head=11,tail=4)
        # println(method)

        df_one = DataFrame(CSV.File(file_path, header=1, delim=';'))
        df_one[!, :method] .= method
        # println(first(df_one, 5))
        
        append!(df, df_one, promote=true) 
        
    end

    # println(last(df, 5))

    # unique_n = unique(i -> i, pairs(df[n]))
    unique_n = unique(select(df, 2))
    # println(unique_n)
    unique_p = unique(select(df, 3))
    # println(unique_p)
    unique_m = unique(select(df, 6))
    # println(unique_m)

    for m1 in 1:(length(unique_m.method)-1)
        for m2 in m1+1:length(unique_m.method)
            mm1 = unique_m.method[m1]
            mm2 = unique_m.method[m2]
            for n in unique_n.n
                # println(n)
                for p in unique_p.p
                    # plot
                    # df1 = filter([:n, :p, :num,:tw, :method] => x -> x.n==n && x.p==p && x.method==m1, df)
                    # df2 = filter([:n, :p, :num,:tw, :method] => x -> x.n==n && x.p==p && x.method==m2, df)
                    df1 = filter(x -> x.n==n && x.p==p && x.method==mm1, df)
                    df2 = filter(x -> x.n==n && x.p==p && x.method==mm2, df)

                    rename!(df1, :tw => "$mm1")
                    rename!(df2, :tw => "$mm2")

                    # println(first(df1,2))
                    # println(first(df2,2))

                    # df_join = innerjoin(df1, df2, on=:num, makeunique=true)
                    df_join = innerjoin(select(df1, Not([:method])), select(df2, Not([:method])), on=[:name, :n, :p, :num])
                    println(first(df_join, 2))

                    # @df_join df_join scatter(:num, ["$mm1" "$mm2"], title="n=$n p=$p")
                    # plot(df_join[:"$mm1", :"$mm2"], df_join.num, seriestype=:scatter)
                    draw(PNG(output_folder * "$n-$p-$mm1-$mm2.png", 16cm, 16cm), plot(df_join[:,"$mm1"], df_join.num, seriestype=:scatter))

                end
            end
        end
    end
end

    
function main()
    # folder_name = "generated_small/"
    # file = "graph_5_0.75_1.csv"
    # output_folder_name = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM")

    # vizualise_file(file, folder_name, output_folder_name)
    
    folder_name = "total/10"
    vizualise_statistics(folder_name)
end

main()

end