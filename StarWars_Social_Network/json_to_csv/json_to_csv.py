__author__ = 'marti'
import os
import networkx as nx
import json

data_location = '../Gabasova 2016/networks'
for file_name in os.listdir(data_location):
    if not file_name.endswith('.json'):
        continue
    print(file_name)
    data = json.load(open(os.path.join(data_location, file_name), 'r'))
    print(data)
    G = nx.node_link_graph(data)
    print(G.nodes(data=True))
    print(G.edges(data=True))
    node_file = file_name.replace('.json', '.nodes.csv')
    edge_file = file_name.replace('.json', '.edges.csv')
    with open(node_file, 'w', encoding='utf-8') as result:
        result.write('Id,name,value,colour\n')
        for node in G.nodes:
            result.write(','.join([str(node), G.nodes[node]['name'], str(G.nodes[node]['value']), G.nodes[node]['colour']]) + '\n')
    with open(edge_file, 'w', encoding='utf-8') as result:
        result.write('source,target,value\n')
        for edge in G.edges:
            result.write(','.join([str(edge[0]), str(edge[1]), str(G.edges[edge]['value'])]) + '\n')

