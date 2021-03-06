# Factors Help Us Make Better Plots {#factors_help_us_make_better_plots}



This chapter covers

- Using factors successfully though inspection and transformation with base **R** functions and functions from the **forcats** package
- Creating **ggplot** bar charts that make the best use of factor variables

Factors are a thing in **R**. They might come off, upon first or subsequent encounters, as something you'd never want to touch. The problem might be that they are difficult to understand and perhaps they have a reputation for being less than useful. However, this chapter intends to change their image a little bit. Really, factors shouldn't be something to be avoided as they are genuinely useful, especially in the context of plotting data with **ggplot**.

We'll use a dataset called `german_cities` (available in the **dspatterns** package) to work through examples that involve factors, eventually getting to nicer and nicer plots. The functions that we'll use throughout this chapter will be an even mix of base **R** functions that work well with factors and functions that are available in the *Tidyverse* packages **forcats** and **ggplot**.

## All About Factors

Factors as an **R** data type are used to represent categorical data. They are vectors that contain levels: integers that describe the ordering of the factor's values. They are often misunderstood and are largely avoided on account of that. The reasons for their non-use may stem from their non-intuitive behavior in functions or the perception that non-factor-based solutions work just as well. But they can be useful, and this section will try to prove that.

The *Tidyverse* package **forcats** will be used here for handling factor values. We have an interesting dataset available in the **dspatterns** package called `german_cities.` It's a bit like the `us_cities` dataset we used in *Chapter 5* except it's smaller (only 79 rows) and has two factor columns (`name` and `state`). A dataset like this may be used by statisticians to analyze population trends, or, it might be used in combination with other domain-specific data (e.g., in advertising/marketing, scientific studies, etc.). Here is a printout of the `german_cities` tibble.

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Printing out the <code>german_cities</code> dataset, which has two factor columns.</p>`{=html}

```r
german_cities
#> # A tibble: 79 x 4
#>   name              state               pop_2015 pop_2011
#>   <fct>             <fct>                  <int>    <int>
#> 1 Aachen            Nordrhein-Westfalen   245885   236420
#> 2 Augsburg          Bayern                286374   267767
#> 3 Bergisch Gladbach Nordrhein-Westfalen   111366   108878
#> 4 Berlin            Berlin               3520031  3292365
#> 5 Bielefeld         Nordrhein-Westfalen   333090   326870
#> 6 Bochum            Nordrhein-Westfalen   364742   362286
#> # ??? with 73 more rows
```

As with all datasets in the **dspatterns** package, more information about them can be obtained in the help system. In this case, using `?german_cities` in the **R** console brings up the help page for this dataset.

### Factors Basics

The first weird thing about factors is that they look like character data in data frames but, when as vectors, don't really print out in the same way. We can experiment with this a bit by using data from the `german_cities` tibble. Let's pull values from the state column, make them unique, and see what we can see from printing `state_fct`:

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Printing out the unique values from the <code>state</code> column of <code>german_cities</code> (obtained as a vector through <code>$</code> indexing).</p>`{=html}

```r
state_fct <- unique(german_cities$state)

state_fct
#>  [1] Nordrhein-Westfalen    Bayern                 Berlin                
#>  [4] Niedersachsen          Bremen                 Sachsen               
#>  [7] Hesse                  Th??ringen              Baden-W??rttemberg     
#> [10] Sachsen-Anhalt         Hamburg                Schleswig-Holstein    
#> [13] Rheinland-Pfalz        Brandenburg            Mecklenburg-Vorpommern
#> [16] Saarland              
#> 16 Levels: Baden-W??rttemberg Bayern Berlin Brandenburg Bremen Hamburg ... Th??ringen
```

Except for the last line, one would think (without checking) that `state_fct` is a character vector, but the mention of `Levels` is a dead giveaway that we are dealing with a factor vector.

Using unique values for the vector is pretty instructive here since the 16 unique values have 16 factor levels. But what's a level in this world of factors? It's an integer value that determines the ordering of the strings. There are a number of base **R** functions that let us do diagnostics on factor. To see all the levels and, separately, the integer values associated with them, we can use the `levels()` and even the `as.integer()` functions (as shown in the next two code listings).

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Getting all the levels for the <code>state_fct</code> factor using the <code>levels()</code> function.</p>`{=html}

```r
levels(state_fct)
#>  [1] "Baden-W??rttemberg"      "Bayern"                 "Berlin"                
#>  [4] "Brandenburg"            "Bremen"                 "Hamburg"               
#>  [7] "Hesse"                  "Mecklenburg-Vorpommern" "Niedersachsen"         
#> [10] "Nordrhein-Westfalen"    "Rheinland-Pfalz"        "Saarland"              
#> [13] "Sachsen"                "Sachsen-Anhalt"         "Schleswig-Holstein"    
#> [16] "Th??ringen"
```

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Getting the integer values for the factor levels in <code>state_fct</code> with <code>as.integer()</code>.</p>`{=html}

```r
as.integer(state_fct)
#>  [1] 10  2  3  9  5 13  7 16  1 14  6 15 11  4  8 12
```

When getting the levels through `levels()` we see that the state names are in alphabetical order. This is the default behavior of **R** when transforming character data to factors (i.e., during data import) and it's likely what has occurred during the creation of the `german_cities` dataset. So, in the output of the last code listing, `10` is `"Nordrhein-Westfalen"`, `2` is `"Bayern"`, and so on. It's the same order of cities as in the `state_fct` vector but the factors were based on the alphabetical ordering of the cities.

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Understanding the frequency of factor levels with the <strong>forcats</strong> <code>fct_count()</code> function.</p>`{=html}

```r
fct_count(german_cities$state)
#> # A tibble: 16 x 2
#>   f                     n
#>   <fct>             <int>
#> 1 Baden-W??rttemberg     9
#> 2 Bayern                8
#> 3 Berlin                1
#> 4 Brandenburg           1
#> 5 Bremen                2
#> 6 Hamburg               1
#> # ??? with 10 more rows
```

It's good to know this and be continually reminded of this behavior. This ordering of factor levels in this default manner is rarely what one really wants (and we'll see why soon enough).

Let's take a subset of the data in `german_cities` so that, for the next few examples, we'll only work directly with a single factor variable. We can do this with **dplyr**'s `filter()` function:

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Filtering the cities in <code>german_cities</code> to those in the state of Bayern.</p>`{=html}

```r
german_cities_bayern <-
  german_cities %>%
  filter(state == "Bayern")

german_cities
#> # A tibble: 79 x 4
#>   name              state               pop_2015 pop_2011
#>   <fct>             <fct>                  <int>    <int>
#> 1 Aachen            Nordrhein-Westfalen   245885   236420
#> 2 Augsburg          Bayern                286374   267767
#> 3 Bergisch Gladbach Nordrhein-Westfalen   111366   108878
#> 4 Berlin            Berlin               3520031  3292365
#> 5 Bielefeld         Nordrhein-Westfalen   333090   326870
#> 6 Bochum            Nordrhein-Westfalen   364742   362286
#> # ??? with 73 more rows
```

Now that the `german_cities` tibble has been filtered to only those cities in Bayern (of which there are eight in this dataset), let's sanity check our levels in the `name` column (which is, like `state`, a factor). We can use the base **R** `nlevels()` function to get the number of levels. While you might expect `nlevels(german_cities_bayern$name)` to return the number `8` (because we can clearly see just eight different city names) what's returned is, surprisingly, `79`. Turns out that the factor levels of a factor don't change even when the elements of such a vector do change. We can remedy this either with the base **R** function `droplevels()` or the **forcats** function `fct_drop()`. The upcoming code listing uses `fct_drop()` twice inside of `mutate()` to remove unneeded factor levels from the `name` and `state` columns.

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Dropping unused factor levels in the <code>name</code> and <code>state</code> <code>&quot;factor&quot;</code> columns with <code>fct_drop()</code>.</p>`{=html}

```r
german_cities_bayern <- 
  german_cities_bayern %>% 
  mutate(
    name = fct_drop(name),
    state = fct_drop(state)
  )

c(nlevels(german_cities_bayern$name), nlevels(german_cities_bayern$state))
#> [1] 8 1
```

The factor levels are now cleaned up for the two factor variables `name` and `state.` Why do this? Well, factor levels are often used to create legends in **ggplot** so it's vitally important that they are in sync with the data (otherwise you'll get legends that don't reflect the plotted data). The **ggplot** package trusts that any factors provided are correct and doesn't attempt to reorder factor levels during plotting.

### Plotting Data with Factor Variables

Speaking of plots, let's make one! This time: a bar plot. The `geom_bar()` function from **ggplot** will be used to draw the layer with the bars. In this particular bar plot, let's have each city in Bayern constitute a bar and the value of the `pop_2015` variable will be the length of the bar. I've found it preferable to have this kind of data visualized as a horizontal bar plot (because the names are more readable that way). There are two details that will make this plot work for us: (1) for the plot aesthetics, map the categorical variable to `y` and map the numeric variable to `x`, and, (2) in `geom_bar()`, use `stat = "identity"` (this means the values provided really are the values that ought to be used). This code listing provides us with the code to give us a horizontal bar plot of populations for eight cities in the German state of Bayern:

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Creating a barplot of the most populous German cities in the state of Bayern by using <strong>ggplot</strong> and its <code>geom_bar()</code> function.</p>`{=html}

```r
ggplot(data = german_cities_bayern, aes(y = name, x = pop_2015)) +
  geom_bar(stat = "identity")
```

<div class="figure" style="text-align: center">
<img src="factors_help_us_make_better_plots_files/figure-html/barplot-bayern-1-1.png" alt="(ref:barplot-bayern-1)" width="70%" />
<p class="caption">(\#fig:barplot-bayern-1)(ref:barplot-bayern-1)</p>
</div>
(ref:barplot-bayern-1) Our first bar plot made with **ggplot**. We really need to fix the ordering of the bars.

The resulting plot of *Figure \@ref(fig:barplot-bayern-1)* makes sense and is technically correct: the lengths of the bars do correspond to the city populations. However, it's also a bit disappointing as a visualization because the cities are arranged in reverse alphabetical order (moving from top to bottom), which is arbitrary with regard to population and doesn't give us an easy way to determine rank. This is where the usefulness of factors enters the picture. We can exploit factor levels to enforce the ordering of variables in **ggplot**. To do all this, we'll use a few functions from **forcats** to modify factor levels and serve our visualization needs.

The `fct_reorder()` function works wonders when you want to have the order of factor levels correspond to the order of a different variable. With the bar plot of cities (*Figure \@ref(fig:barplot-bayern-1)*) it was lamentable that the order of the bars did nothing to communicate the rank of cities by their population. Now, we can do something about it with **forcats**' `fct_reorder()`. The following code listing uses an indexing assignment approach (in contrast to the `mutate()` approach used earlier) to reorder the levels of the name variable on the basis of the city population (the `pop_2015` variable).
	
`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Using the <code>fct_reorder()</code> function to reorder the factor levels of the name variable to match the ordering of the <code>pop_2015</code> variable.</p>`{=html}

```r
german_cities_bayern$name <- 
  fct_reorder(german_cities_bayern$name, german_cities_bayern$pop_2015)

levels(german_cities_bayern$name)
#> [1] "Erlangen"   "F??rth"      "W??rzburg"   "Ingolstadt" "Regensburg"
#> [6] "Augsburg"   "N??rnberg"   "Munich"
```

We checked our work by using the `levels()` function for manual inspection of the levels. We now get an ordering that is no longer alphanumeric. This is success! We'll really see it, though, when the bar plot is regenerated. We can re-run the plotting code and it'll give us a radically improved plot (*Figure \@ref(fig:barplot-bayern-2)*).

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Regenerating the barplot of the most populous German cities in the state of Bayern (this is version 2).</p>`{=html}

```r
ggplot(data = german_cities_bayern, aes(y = name, x = pop_2015)) +
  geom_bar(stat = "identity")
```

<div class="figure" style="text-align: center">
<img src="factors_help_us_make_better_plots_files/figure-html/barplot-bayern-2-1.png" alt="(ref:barplot-bayern-2)" width="70%" />
<p class="caption">(\#fig:barplot-bayern-2)(ref:barplot-bayern-2)</p>
</div>
(ref:barplot-bayern-2) An improvement on the bar plot of large cities in Bayern, Germany. Reordering factor levels in the name variable leads to a coherent ordering of cities by population.

Having the bars arranged in this way really helps. We can tell, in an instant, that Ingolstadt has a greater population than W??rzburg. What if you wanted the bars in the reverse order? In that case, the `fct_rev()` function is what's needed. Let's use the function, inspect the factor levels with `levels()`, and re-plot as before (*Figure \@ref(fig:barplot-bayern-3)*).

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Reversing the order of factor levels in the <code>name</code> variable with the <code>fct_rev()</code> function.</p>`{=html}

```r
german_cities_bayern$name <- fct_rev(german_cities_bayern$name)

levels(german_cities_bayern$name)
#> [1] "Munich"     "N??rnberg"   "Augsburg"   "Regensburg" "Ingolstadt"
#> [6] "W??rzburg"   "F??rth"      "Erlangen"
```

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Regenerating the barplot of the most populous German cities in the state of Bayern (this is version 3).</p>`{=html}

```r
ggplot(data = german_cities_bayern, aes(y = name, x = pop_2015)) +
  geom_bar(stat = "identity")
```

<div class="figure" style="text-align: center">
<img src="factors_help_us_make_better_plots_files/figure-html/barplot-bayern-3-1.png" alt="(ref:barplot-bayern-3)" width="70%" />
<p class="caption">(\#fig:barplot-bayern-3)(ref:barplot-bayern-3)</p>
</div>
(ref:barplot-bayern-3) The reversed order of bars in this plot was accomplished by reversing the factor levels of the name variable with `fct_rev()`.

Lastly, before moving on to more complex plots (all made possible by **forcats**), let's look at a few more functions for transforming factor levels. A great one is `fct_recode()`. If you ever wanted to change the values of the factor levels. Say, for instance, you didn't want the `??` characters to appear in the city names of `"F??rth"`, `"W??rzburg"`, and `"N??rnberg"` and would rather use `"Fuerth"`, `"Wuerzburg"`, and `"Nuernberg"`; then it's `fct_recode()` to the rescue:

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Recoding factor levels in name with the <code>fct_recode()</code> function.</p>`{=html}

```r
german_cities_bayern$name <- 
  fct_recode(
    german_cities_bayern$name,
    "Fuerth" = "F??rth", "Wuerzburg" = "W??rzburg",
    "Nuernberg" = "N??rnberg", "Muenchen" = "Munich"
    )

levels(german_cities_bayern$name)
#> [1] "Muenchen"   "Nuernberg"  "Augsburg"   "Regensburg" "Ingolstadt"
#> [6] "Wuerzburg"  "Fuerth"     "Erlangen"
```

Again, we need to plot this data to really believe that this use of `fct_recode()` will change the plot labels (*Figure \@ref(fig:barplot-bayern-4)*).

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Regenerating the barplot of the most populous German cities in the state of Bayern (this is version 4).</p>`{=html}

```r
ggplot(data = german_cities_bayern, aes(y = name, x = pop_2015)) +
  geom_bar(stat = "identity")
```

<div class="figure" style="text-align: center">
<img src="factors_help_us_make_better_plots_files/figure-html/barplot-bayern-4-1.png" alt="(ref:barplot-bayern-4)" width="70%" />
<p class="caption">(\#fig:barplot-bayern-4)(ref:barplot-bayern-4)</p>
</div>
(ref:barplot-bayern-4) Thanks to selectively recoding factor values with `fct_recode()`, some of the city names have been slightly altered. The rest of the plot remains unchanged.

### Plotting Data with More Advanced Treatments of Factors

Let's take the same dataset, `german_cities`, and get a bar plot that indicates how many cities are in each state. The use of `geom_bar()` is now different than what was used earlier. This time we will use the `stat = "count"` option but, since that's the default for `geom_bar()`, we'll just omit that altogether. Have a look at the **ggplot** code and the resulting plot in *Figure \@ref(fig:barplot-count)*.

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Creating a bar plot that is based on counts of cities in each state, which is mapped to the <code>y</code> aesthetic.</p>`{=html}

```r
german_cities %>%
  ggplot(aes(y = state)) +
  geom_bar()
```

<div class="figure" style="text-align: center">
<img src="factors_help_us_make_better_plots_files/figure-html/barplot-count-1.png" alt="(ref:barplot-count)" width="70%" />
<p class="caption">(\#fig:barplot-count)(ref:barplot-count)</p>
</div>
(ref:barplot-count) A bar plot that shows the number of cities in the dataset that are part of each state. We need to order the bars, however, to make this a more effective visualization (it's hard to parse at present).

The plot in *Figure \@ref(fig:barplot-count)* is, just like that of *Figure \@ref(fig:barplot-bayern-1)*, unsatisfactory as a visualization since the bars (corresponding to counts of cities in each state) are not ordered by their lengths. The **forcats** package offers a very useful function that assigns frequency values to factor levels: `fct_infreq()`. Let's use `fct_infreq()` in a `mutate()` statement along with `fct_rev()` as a way to reverse the levels, just as we've done before. In the next code listing the dataset is mutated with those factor adjustments and the table is then introduced to `ggplot()` via the `%>%`. The much-improved plot is shown in *Figure \@ref(fig:fct-infreq)*.

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Improving on the city count bar plot through use of the <code>fct_infreq()</code> and <code>fct_rev()</code> functions.</p>`{=html}

```r
german_cities %>%
  mutate(state = state %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(y = state)) +
  geom_bar()
```

<div class="figure" style="text-align: center">
<img src="factors_help_us_make_better_plots_files/figure-html/fct-infreq-1.png" alt="(ref:fct-infreq)" width="70%" />
<p class="caption">(\#fig:fct-infreq)(ref:fct-infreq)</p>
</div>
(ref:fct-infreq) An improved bar plot that made use of the `fct_infreq()` function (to assign levels according to frequency) and, following that, the `fct_rev()` function (to reverse the order of levels).

The plot shown in *Figure \@ref(fig:fct-infreq)* is a great improvement over the previous one in *Figure \@ref(fig:barplot-count)*, proving yet again that factors, and the careful manipulation of them, are useful for controlling plot presentation.

Regarding the reordering of factor levels, there are two other **forcats** functions you should know about. One is the `fct_inorder()` function. Using that on a factor will assign levels based on the order in which values first appear. This function could be handy should you have a table arranged just so, and you wanted to preserve the order of factor values in a plot.

The other function worth mentioning is the `fct_inseq()`. What that does is transform a factor's levels to match the numeric values of the factor. This one's a little confusing so let's demonstrate its use. First, let's make a factor from scratch with the base **R** `factor()` function. We'll provide an integer vector, defined by `3:8`, to `factor()` and a corresponding character vector of integer values to levels (but it'll be in a jumbled up order). Then, we'll get the levels of the factor before and after using the `fct_inseq()` function.

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Using the <code>fct_inseq()</code> function to reorder a factor's levels by its numeric values.</p>`{=html}

```r
fctr <- factor(3:8, levels = as.character(c(5, 4, 6, 3, 8, 7)))

fctr %>% levels()
#> [1] "5" "4" "6" "3" "8" "7"

fctr %>% fct_inseq() %>% levels()
#> [1] "3" "4" "5" "6" "7" "8"
```

From this code chunk we get two outputs, the first shows the levels as defined by the `factor()` statement, the second set of levels has been modified by `fct_inseq()` such that the order now matches the values of factor (the sequence of numbers from `3` to `8`). The `fct_inseq()` function could be very useful in situations where factor-based values are in terms of years, months, or some other numeric value where ordering numerically makes sense.

Let's get back to our bar plot (which now looks great by the way, thanks to **forcats**). We might imagine a situation where the total number of categories is exceedingly large and so we'd want to show just a few categories while lumping the rest into an 'others' category. Amazingly there is a set of **forcats** functions for that, and the function names all begin with `fct_lump_`. All of these variations perform lumping by different criteria; we'll choose to use the `fct_lump_n()` function for our next example. It lumps all levels except for the n most frequent of them.

The example shown in the next code listing synthesizes a number of `fct_*()` functions together to modify the levels of the state factor column in a `mutate()` statement. First, we do as before and obtain factor levels by frequency. Then, we use `fct_lump_n()` to get the five top states in terms of city count, lumping the rest into the `"Other"` level. Finally, we reverse the entire order of levels with `fct_rev()` so that the bars in the plot appear from largest to smallest (from top to bottom), with the `"Other"` level at the very bottom.

`<p style="margin-bottom: 0; font-size: 14px"><strong>CODE //</strong> Further refinement of the city count bar plot by incorporating the <code>fct_lump_n()</code> function (just before reversing levels).</p>`{=html}

```r
german_cities %>%
  mutate(state = state %>% fct_infreq() %>% fct_lump_n(5) %>% fct_rev()) %>%
  ggplot(aes(y = state)) +
  geom_bar()
```

<div class="figure" style="text-align: center">
<img src="factors_help_us_make_better_plots_files/figure-html/fct-lump-n-1.png" alt="(ref:fct-lump-n)" width="70%" />
<p class="caption">(\#fig:fct-lump-n)(ref:fct-lump-n)</p>
</div>
(ref:fct-lump-n) This bar plot of states and the count of cities within them now has an 'Other' bar that represents the count of cities in all other states not in the highlighted five.

While this exploration of factors, the functionality available in **forcats** for modifying them, and these bar plots is useful enough, there is so much more to explore. I strongly suggest looking at the website for **forcats**, which is at https://forcats.tidyverse.org/. There, you'll find a *Getting Started* article, a function *Reference* section, and, a *Cheetsheet* that succinctly shows how all the functions work and are tied together. Sure, factors can be a pain, but working toward understanding them better really does lead to better plots and that really makes it all worth the effort.

## Summary

- Factors are vectors that contain levels: integers that describe the ordering of the factor's values; we can inspect factors with a number of useful base **R** functions (`as.integer()`, `levels()`, `nlevels()`, etc.) and the `fct_count()` function from the **forcats** package
- Should factors vectors get modified by changing the number of elements, the storage of factor levels is not changed (and we may have levels for nonexistent values): remedy this with `fct_drop()`
- We can get fine control over plotting categorical data when using factor transformation functions from **forcats** just before using **ggplot**; these **forcats** functions were useful in this regard: `fct_reorder()`, `fct_rev()`, `fct_recode()`, `fct_infreq()`, `fct_inseq()`, and `fct_lump_n()`.
