# # How to use bundle adjustment models

# \toc

# ## Get the list of problems

using BundleAdjustmentModels

# Using the 'problems_df()' function will show you a dataframe of all the bundle adjustment problems.

# Since there are 74 different matrices, you can sort the dataframe depending on

# - the name of the model
# - the group of the model
# - the size of matrix (nequ, nvar)
# - the number of non-zeros elements (nnzj)

df = problems_df()
filtered_df = df[ ( df.nequ .≥ 50000 ) .& ( df.nvar .≤ 34000 ), :]

# In the example above, we wanted the mattrix to have at least 50000 lines and less than 34000 columns

# This dataframe is only listing the matrices that you can have access to, but in order to use them you need to download them and that's how this package is really useful.

# First, let's see how you can do it and then we'll explain how it's done

# As you can see just above, we got a dataframe of two problems that we filtered. What we want to do now is to select the first one in the listing

name, group = get_first_name_and_group(filtered_df)

# What this method did is that it selected the name and the group of the problem in the dataframe.

# Now that you got the name and the groupe you probably want to have access to the problem itself. And there are 2 solutions :

# - You can download the raw file
# - You can automatically create a non linear least square problem using NLPModels from JuliaSmoothOptimizers

# ## Get the raw file

# First, you might wonder, why did I go through all of this to get a file I can directly download on the original website if I don't want to use NLPModels.
# The reason is : **it is cleaner**. We use Julia Artifacts technology so this way :

# 1. You download every matrix only once
# 2. It is identified with a unique hash so you can always find it back 
# 3. You can delete it all with a single command line

path = fetch_ba_name(name, group)

# This method, used with the variables `name` and `group` defined above, will automatically download the problem and give you the path to it.
# If it is already downloaded it will simply get you the path to it.

# You can also directly download and get access to an entire group of problems like this :

paths = fetch_ba_group("ladybug")
println(length(paths))
println(paths[1])

# It will return a vector of the paths to all the problems.

# ## Generate a non linear least square model

# Now, let's say you want to work on the model itself.

model = BundleAdjustmentModel(name, group)

# Or

model = BundleAdjustmentModel("problem-49-7776-pre", "ladybug")

# This command will generate the model out of the `name` and `group` variables defined above (and automatically download it if it's not been done already).

# If you already have downloaded one of the problems or modified it yourself, you can use the following method `BundleAdjustmentModel("../path/to/file/problem-49-7776-pre.txt.bz2")`.

# ## Using the model

# Now that you have your model and all its metadata in your `model` variable you might want to use it.

using NLPModels
using LinearAlgebra

# ### Residual of the model

# You can calculate the residual of the model :

x = model.meta.x0
Fx = residual(model,x)
println(norm(Fx))

# The in place method is also available if you don't want to use too much memory

Fx = zeros(model.nls_meta.nequ)
Fx = residual!(model,x,Fx)
println(norm(Fx))

# ### Jacobian of the model

# You can also have access to the jacobian of the model which is calculated by hand (in contradiction to automatic differentiation).

Jx = jac_op_residual(model,x)

# ## Delete the problems

# Once you have finished working with a specific model you can delete it the same way you downloaded it.

delete_ba_artifact!(name, group)

# A small Info will appear to tell you if it's been successfully deleted.

# Now if you want to clean your workspace or save some space you can delete all the problems at once.

delete_all_ba_artifacts!()

# That's it for this tutorial ! If you have any problems with the package don't hesitate to open an issue and I will try to fix it.
