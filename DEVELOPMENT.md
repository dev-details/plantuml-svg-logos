# Add a logo

## Install SVGO

[SVGO](https://github.com/svg/svgo) is required to optimize SVGs

## Find an SVG URL

Searching for "{brandname} svg logo" in Google is usually enough.

This site tends to come up the most in the results:

- https://worldvectorlogo.com/

Another place to look is the brand website's presskit or marketing material.

Once you find the logo, check the brand's website to make sure it's the 
current logo.

Copy the URL to the SVG then run:

    .build/convert1.sh <sprite_name> <svg_url>

This will generate a `plantuml/<sprite_name>.puml` file.

## Preview logo

If you have `plantuml` installed, you can generate a preview for the sprite:

    .build/preview.sh <sprite_name>

If you do not have `plantuml` installed, you the following command to generate
the PlantUML code and put it in your clipboard. You can then paste it into
your IDE's PlantUML renderer (Online renderes like http://www.plantuml.com/plantuml/ do not support inline sprites).

    .build/preview.sh --stdout <sprite_name> | pbcopy

## Open a pull request

Commit `plantuml/<sprite_name>.puml` with a message such as
"Added <sprite_name> logo" and open a pull request to the `main` branch
of https://github.com/dev-details/plantuml-svg-logos.

In the PR description, paste the preview logo so reviewers can see how 
it is rendered.
