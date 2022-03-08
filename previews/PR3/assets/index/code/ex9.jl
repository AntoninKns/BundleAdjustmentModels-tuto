# This file was generated, do not modify it. # hide
x = model.meta.x0
Fx = residual(model,x)
println(norm(Fx))