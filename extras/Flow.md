# Aqua-wide params







1. First options parsing - populates common opts into `Context`:
    * It's done with option parser with `strict` and only common args. Can be found in contexts's `common_args`
1. Aqua loads:
    * Populates in `local config` to `Context`. 
    * Also, applies configuration
    * Defines, if it's ran inside the project: `umbrella`, `flat` or `none`

    **NOTE**: Here, already `common_args` are used (for example for verbosity)
1. Template is donloaded:
    * If `common_args` update is set to true - template is tried to be updated
    * If `update_always` in config is set to true - template is updated in all cases
1. 