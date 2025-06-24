module Statistics

using DataFrames
using CSV

export get_statistics_for_method


function read_result_file(file_name::AbstractString, folder_name::AbstractString, folder_path::AbstractString)
    cd(@__DIR__)
    file_path = folder_path * folder_name * "/" * file_name
    # println(file_path)
    if !endswith(file_path, ".csv") || !isfile(file_path)
        throw(error("Not a file:\t" * file_path))
    end
    
    tw = 0
    
    open(file_path) do file
        lines = readlines(file)

        for s in lines
            l = split(split(s, ',')[3], ';')
            # println(l)

            if length(l) - 1 > tw
                tw = length(l) - 1
                # println(tw)
            end
        end
    end

    # println(tw)
    return tw

end

function get_statistics(folder_path::AbstractString)
    cd(@__DIR__)
    folder_list = readdir(folder_path)
    # println(folder_list)
    statistics_folder = replace(folder_path, "results" => "statistics")
    mkpath(statistics_folder)

    for folder in folder_list
        # println(folder)
        file_list = readdir(folder_path * folder * "/")

        df = DataFrame(name=String[], n=String[], p=String[], num=String[], tw=Int64[])
        for file in file_list
            # println(file)
            f = split(chop(file, tail=4), '_')
            n = f[3]
            p = f[4]
            num = f[5]

            tw = read_result_file(file, folder, folder_path)
            # println(tw)

            push!(df, [file, n, p, num, tw])
        end

        CSV.write(statistics_folder * "statistics_" * folder * ".csv", df, delim=';')
        
        df2 = DataFrame(CSV.File(statistics_folder * "statistics_" * folder * ".csv", header=1, delim=';'))
        println(df2)
    end

end


function get_statistics_for_method(folder_path::AbstractString, method)
    cd(@__DIR__)
    folder_list = readdir(folder_path)
    # println(folder_list)
    statistics_folder = replace(folder_path, "results" => "statistics")
    mkpath(statistics_folder)

    if method == 1
        folder = "gmd"
    end
    if method == 2
        folder = "gmf"
    end
    if method == 3
        folder = "gmc"
    end

    # println(folder)
    file_list = readdir(folder_path * folder * "/")

    df = DataFrame(name=String[], n=String[], p=String[], num=String[], tw=Int64[])
    for file in file_list
        # println(file)
        f = split(chop(file, tail=4), '_')
        n = f[3]
        p = f[4]
        num = f[5]

        tw = read_result_file(file, folder, folder_path)
        # println(tw)

        push!(df, [file, n, p, num, tw])
    end

    CSV.write(statistics_folder * "statistics_" * folder * ".csv", df, delim=';')
    # println(df)

    # df2 = DataFrame(CSV.File(statistics_folder * "statistics_" * folder * ".csv", header=1, delim=';'))
    # println(df2)

end


function read_statistics(timestamp::AbstractString)
    cd(@__DIR__)
    result_folder = "../output/results/" * timestamp * "/"
    statistics_folder = "../output/statistics/" * timestamp * "/"

    times = filter!(x -> endswith(x, ".txt"), readdir(result_folder))
    # println(times)

    statistics = []
    for time in times
        println(time)
        t = 0
        open(result_folder * time) do file
            t = split(readlines(file)[1], ' ')[1]
            println(t)
        end

        method = chop(time, tail=4)

        df = DataFrame(CSV.File(statistics_folder * "statistics_" * method * ".csv", header=1, delim=';'))
        println(df)

    end
end


function main()
    folder_path = "../output/results/test_small/2025-06-22_17-03/"
    # get_statistics(folder_path)

    # folder = "gmd"
    # file = "result_graph_5_0.5_1.csv"
    # read_result_file(file, folder, folder_path)

    timestamp = "2025-06-22_23-40"
    read_statistics(timestamp)

end

# main()

end