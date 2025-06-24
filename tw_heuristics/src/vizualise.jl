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

        method = chop(file, head=11, tail=4)
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
                    df1 = filter(x -> x.n == n && x.p == p && x.method == mm1, df)
                    df2 = filter(x -> x.n == n && x.p == p && x.method == mm2, df)

                    rename!(df1, :tw => "$mm1")
                    rename!(df2, :tw => "$mm2")

                    df_join = innerjoin(select(df1, Not([:method])), select(df2, Not([:method])), on=[:name, :n, :p, :num])
                    # println(first(df_join, 2))

                    plot(df_join.num, df_join[:, "$mm1"], seriestype=:scatter, label="$mm1", mc=:blue, msw=0, ms=4, ma=0.85, size=(1500, 1000))
                    plot!(df_join.num, df_join[:, "$mm2"], seriestype=:scatter, label="$mm2", mc=:red, msw=0, ms=4, ma=0.85, size=(1500, 1000))
                    title!("n=$n, p=$p")
                    # gui()
                    # sleep(60)

                    png(output_folder * "$n-$p-$mm1-$mm2.png")
                end
            end
        end
    end
end


function vizualise_statistics_together(folders)
    cd(@__DIR__)

    df = DataFrame(name=String[], n=String[], p=String[], num=String[], tw=Int64[], method=String[])
    output_folder = "../output/vizualisation/total/"

    for folder_name in folders
        folder = "../output/statistics/" * folder_name * "/"
        mkpath(output_folder)

        files = readdir(folder)

        for file in files
            # println(file)
            file_path = folder * file
            if !endswith(file_path, ".csv") || !isfile(file_path)
                throw(error("Not a file:\t" * file_path))
            end

            method = chop(file, head=11, tail=4)
            # println(method)

            df_one = DataFrame(CSV.File(file_path, header=1, delim=';'))
            df_one[!, :method] .= method
            # println(first(df_one, 5))

            append!(df, df_one, promote=true)

        end
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

            df1 = filter(x -> x.method == mm1, df)
            df2 = filter(x -> x.method == mm2, df)

            rename!(df1, :tw => "$mm1")
            rename!(df2, :tw => "$mm2")

            df_join = innerjoin(select(df1, Not([:method])), select(df2, Not([:method, :p, :n])), on=[:name, :num])
            # println(first(df_join, 2))

            plot(df_join.n, df_join[:, "$mm1"], seriestype=:scatter, label="$mm1", mc=:blue, msw=0, ms=4, ma=0.75, size=(1500, 1000))
            plot!(df_join.n, df_join[:, "$mm2"], seriestype=:scatter, label="$mm2", mc=:red, msw=0, ms=4, ma=0.75, size=(1500, 1000))
            # title!("n=$n, p=$p")
            # gui()
            # sleep(60)

            png(output_folder * "n-$mm1-$mm2.png")

            df_join = innerjoin(select(df1, Not([:method])), select(df2, Not([:method, :p, :n])), on=[:name, :num])
            # println(first(df_join, 2))

            plot(df_join.p, df_join[:, "$mm1"], seriestype=:scatter, label="$mm1", mc=:blue, msw=0, ms=4, ma=0.75, size=(1500, 1000))
            plot!(df_join.p, df_join[:, "$mm2"], seriestype=:scatter, label="$mm2", mc=:red, msw=0, ms=4, ma=0.75, size=(1500, 1000))
            # title!("n=$n, p=$p")
            # gui()
            # sleep(60)

            png(output_folder * "p-$mm1-$mm2.png")

        end
    end
end


function vizualise_total()
    cd(@__DIR__)

    # file = "../output/vizualisation/total/results.csv"
    file = "../output/vizualisation/total/results.csv"
    output_folder = "../output/vizualisation/total/"

    df = DataFrame(CSV.File(file, header=1, delim=';'))


    # df[!, :"t(gmc)"] = parse.(Float64, df[!, :"t(gmc)"])
    # df[!, :"t(gmd)"] = parse.(Float64, df[!, :"t(gmd)"])
    # df[!, :"t(gmf)"] = parse.(Float64, df[!, :"t(gmf)"])

    # df[!, :"t(gmc)"] = convert.(Int64, df[!, :"t(gmc)"])
    # df[!, :"t(gmd)"] = convert.(Int64, df[!, :"t(gmd)"])
    # df[!, :"t(gmf)"] = convert.(Int64, df[!, :"t(gmf)"])

    # transform!(df, :"t(gmc)" => ByRow(x -> parse(Int, split(x, ',')[1])) => :"t(gmc)i")
    # transform!(df, :"t(gmd)" => ByRow(x -> parse(Int, split(x, ',')[1])) => :"t(gmd)i")
    # transform!(df, :"t(gmf)" => ByRow(x -> parse(Int, split(x, ',')[1])) => :"t(gmf)i")

    # println(first(df, 5))

    transform!(df, :"t(gmc)" => ByRow(x -> parse(Int, split(string(x), ",")[1])) => :"t(gmc)")
    transform!(df, :"t(gmd)" => ByRow(x -> parse(Int, split(string(x), ",")[1])) => :"t(gmd)")
    transform!(df, :"t(gmf)" => ByRow(x -> parse(Int, split(string(x), ",")[1])) => :"t(gmf)")

    # transform!(df, :"t(gmc)" => x -> parse(Int, split(x, ',')[1]) => :"t(gmc)")

    # plot(df.n, df[:, [:"t(gmc)", :"t(gmd)", :"t(gmf)"]])
    plot!(df.n, df[:, :"t(gmc)"], label="gmc", yscale=:log10, size=(1500, 1000))
    plot!(df.n, df[:, :"t(gmd)"], label="gmd", yscale=:log10, size=(1500, 1000))
    plot!(df.n, df[:, :"t(gmf)"], label="gmf", yscale=:log10, size=(1500, 1000))
    gui()
    # sleep(60)
    png(output_folder * "time.png")


    transform!(df, :"A(gmc)" => ByRow(x -> parse(Int, split(string(x), ",")[1])) => :"A(gmc)")
    transform!(df, :"A(gmd)" => ByRow(x -> parse(Int, split(string(x), ",")[1])) => :"A(gmd)")
    transform!(df, :"A(gmf)" => ByRow(x -> parse(Int, split(string(x), ",")[1])) => :"A(gmf)")

    plot(df.n, df[:, :"A(gmc)"], label="gmc", size=(1500, 1000))
    plot!(df.n, df[:, :"A(gmd)"], label="gmd", size=(1500, 1000))
    plot!(df.n, df[:, :"A(gmf)"], label="gmf", size=(1500, 1000))
    gui()
    # sleep(60)
    png(output_folder * "average.png")


    transform!(df, :"M(gmc)" => ByRow(x -> parse(Int, split(string(x), ",")[1])) => :"M(gmc)")
    transform!(df, :"M(gmd)" => ByRow(x -> parse(Int, split(string(x), ",")[1])) => :"M(gmd)")
    transform!(df, :"M(gmf)" => ByRow(x -> parse(Int, split(string(x), ",")[1])) => :"M(gmf)")

    plot(df.n, df[:, :"M(gmc)"], label="gmc", size=(1500, 1000))
    plot!(df.n, df[:, :"M(gmd)"], label="gmd", size=(1500, 1000))
    plot!(df.n, df[:, :"M(gmf)"], label="gmf", size=(1500, 1000))
    gui()
    # sleep(60)
    png(output_folder * "median.png")

end


function main()
    # folder_name = "generated_small/"
    # file = "graph_5_0.75_1.csv"
    # output_folder_name = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM")

    # vizualise_file(file, folder_name, output_folder_name)

    # folder_name = "total/10"
    # vizualise_statistics(folder_name)
    # folder_name = "total/100"
    # vizualise_statistics(folder_name)
    # folder_name = "total/200/025"
    # vizualise_statistics(folder_name)
    # folder_name = "total/200/05"
    # vizualise_statistics(folder_name)
    # folder_name = "total/200/075"
    # vizualise_statistics(folder_name)

    # folders = ["total/10", "total/100", "total/200/025", "total/200/05", "total/200/075"]
    # vizualise_statistics_together(folders)

    vizualise_total()
end

main()

end