module Results

using Graphs


export save_result


function save_result(T, x, file_name, output_folder::String="../output/results/")
    cd(@__DIR__)
    mkpath(output_folder)
    file_path = output_folder * file_name

    if isfile(file_path)
        rm(file_path)
    end

    open(file_path, "w") do io

        for e in T[2]
            println(io, "N" * string(e[1]) * ",N" * string(e[2]) * ",")
        end

        for b in x
            v = "N" * string(b[1]) * ",,"

            n = length(b[2])
            for e = 1:n
                v *= string(b[2][e])
                if e == n
                    break
                end
                v *= ";"
            end
            println(io, v)
        end

    end

end


function main()

end

# main()

end