import matplotlib.pyplot as plt
import numpy as np

x = []
y = []
for i in range(1, 10, 2):
    for j in range(1, 10, 2):
        if j > i:
              x.append(i)
              y.append(j)

highlight_points = [(1, 3), (3, 5), (5, 7), (7, 9)]

colors = ["#5FC8D1" if (xi, yi) in highlight_points else "#FFC0CB" for xi, yi in zip(x, y)]
shapes = ["x" if (xi, yi) not in highlight_points else "o" for xi, yi in zip(x, y)]
fig, ax = plt.subplots()



ax.set(xlim=(0, 10), xticks=np.arange(1, 10),
       ylim=(0, 10), yticks=np.arange(1, 10))
for xi, yi, color, marker in zip(x, y, colors, shapes):
    ax.scatter(xi, yi, c=color, marker=marker)
ax.set_xlabel("Gene rank", fontsize=15)
ax.set_ylabel("Gene rank", fontsize=15)
plt.savefig('class_dot.pdf')
