# This file was generated, do not modify it.

using BundleAdjustmentModels

df = problems_df()
filtered_df = df[ ( df.nequ .≥ 50000 ) .& ( df.nvar .≤ 34000 ), :]

name, group = get_first_name_and_group(filtered_df)

path = fetch_ba_name(name, group)

paths = fetch_ba_group("ladybug")
println(length(paths))
println(paths[1])

model = BundleAdjustmentModel(name, group)

model = BundleAdjustmentModel("problem-49-7776-pre", "ladybug")

using NLPModels
using LinearAlgebra

x = model.meta.x0
Fx = residual(model,x)
println(norm(Fx))

Fx = zeros(model.nls_meta.nequ)
Fx = residual!(model,x,Fx)
println(norm(Fx))

Jx = jac_op_residual(model,x)

delete_ba_artifact!(name, group)

delete_all_ba_artifacts!()

