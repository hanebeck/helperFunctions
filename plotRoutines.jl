# --------------------------------------------------------------------------------------------------
# Collection of plotting routines
# --------------------------------------------------------------------------------------------------
module plotRoutines
# --------------------------------------------------------------------------------------------------
# Includes
# --------------------------------------------------------------------------------------------------
using CairoMakie
using LaTeXStrings
using myDensities
# --------------------------------------------------------------------------------------------------
# Exports
# --------------------------------------------------------------------------------------------------
export publicationFigure, saveFigure, lines_filled!, plotGM, plotSampleSet
# ---------------------------------------------------------------------------------------------
# Global definitions and constants
# ---------------------------------------------------------------------------------------------
theme = Theme(fontsize=8, fonts=(; regular="Latin Modern", bold="Latin Modern"))
# ---------------------------------------------------------------------------------------------
function publicationFigure(width, height; numPlots=(1, 1))
    set_theme!(theme)
    size_mm = (width, height)
    size_inches = size_mm ./ 25.4
    size_pt = 72 .* size_inches
    fig = Figure(size=size_pt, figure_padding=(3, 3, 0, 2))
    if numPlots == (1, 1)
        axes = Axis(fig[1, 1])
    else
        axes = [Axis(fig[i, j]) for i = 1:numPlots[1], j = 1:numPlots[2]]
    end
    # tightlimits!(axes)
    # trim!(fig.layout)
    # resize_to_layout!(fig)
    fig, axes
end
# --------------------------------------------------------------------------------------------------
function saveFigure(fig, figName; basePath="../TeX/Plots/", fileType=".pdf")
    display(fig)
    save(basePath * figName * fileType, fig, pt_per_unit=1)
end
# --------------------------------------------------------------------------------------------------
function lines_filled!(ax, x, y; color=:blue, transparency=0.2, linewidth=1)
    lines!(ax, x, y, color=color, linewidth=linewidth)
    fill_between!(ax, x, y, zeros(size(y)), color=(color, transparency))
end
# --------------------------------------------------------------------------------------------------
function plotGM(ax, w, μ, σ; plotComponents=true, xlims=(-4, 4), color=:red, labels=nothing)
    f(x) = GM(x, w, μ, σ)
    xMin, xMax = xlims
    N = 1000
    xvals = collect(LinRange(xMin, xMax, N))
    yvals = f.(xvals)
    ymax = maximum(yvals)
    lines_filled!(ax, xvals, yvals; color=color)
    L = length(w)
    if plotComponents && L > 1
        for i = 1:L
            yivals = GM.(xvals, w[i], μ[i], σ[i])
            ymax = max(ymax, maximum(yivals))
            lines_filled!(ax, xvals, yivals; color=:blue)
        end
    end
    xlims!(ax, xMin, xMax)
    ylims!(ax, 0, 1.1ymax)
    if labels !== nothing
        ax.title = labels[1]
        ax.xlabel = labels[2]
        ax.ylabel = labels[3]
    end
end

# --------------------------------------------------------------------------------------------------
function plotSampleSet(axes, sampleSet, Gamma)
    L, _ = size(sampleSet)
    for i = 1:L
        lines!(axes, sampleSet[i, :], Gamma, color=:red, linewidth=1)
    end
end
# --------------------------------------------------------------------------------------------------
end#module