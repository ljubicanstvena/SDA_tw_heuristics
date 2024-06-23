module GenerateGraphs

using Graphs


function generate_graph(n, p)
    graph = erdos_renyi(n, p)

    println(graph)
    println(typeof(graph))

    for vertex in vertices(graph)
        println(vertex)
        for neigh in neighbors(graph, vertex)
            print(";")
            print(neigh)
        end
        println()
    end
end

function save_graph(graph::SimpleGraph, file_name::String, output_folder::String="../output/generated/")
    cd(@__DIR__)
    mkpath(output_folder)
    file_path = output_folder * file_name

    if isfile(file_path)
        rm(file_path)
    end

    open(file_path, "w") do io

        for vertex in vertices(graph)
            v = string(vertex)
            for neigh in neighbors(graph, vertex)
                v *= ";"
                v *= string(neigh)
            end
            println(io, v)
        end
    end

end

function generate_graphs()
    ns = [10, 100, 1000]
    # ns = [10]
    ps = [0.25, 0.5, 0.75]
    number = 100 # 100

    for n in ns
        for p in ps
            for num = 1:number
                println("\nGraph " * string(n) * " " * string(p) * " " * string(num))

                graph = erdos_renyi(n, p)

                # println("m " * string(ne(graph)))

                for vertex in vertices(graph)
                    # print(vertex)
                    for neigh in neighbors(graph, vertex)
                        # print(";")
                        # print(neigh)
                    end
                    # println()
                end

                save_graph(graph, "graph_" * string(n) * "_" * string(p) * "_" * string(num) * ".csv")

            end
        end
    end
end


function main()

    # generate_graph(5, 0.5)
    generate_graphs()

end

main()

end