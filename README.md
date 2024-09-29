# flutter_draw_vertices

One of Flutter's lowest-level APIs is the drawVertices method, which allows you to efficiently draw an astounding amount of stuff on the screen. 
That stuff can be lines, rectangles, polygons, particles, and whatever else you can think of. 
This method is how people (including Filip) can even implement specialized 3D renderers on top of Dart that run fast on mobile, web and desktop. 
In this talk, Filip will explain the API of Canvas.drawVertices() and the Vertices.raw() constructor — both are obscure, very low-level, and hard to explain in documentation alone. 
But they are worth it when you need to squeeze the last bit of performance out of Flutter.

![flutter_draw_vertices_demo.gif](flutter_draw_vertices_demo.gif)

See more → [Canvas.drawVertices — Incredibly fast, incredibly low-level, incredibly fun](https://www.youtube.com/watch?v=pD38Yyz7N2E)
