require("neorg").setup {
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
            config = {
                icon_preset = "basic", -- Use basic ASCII preset
                icons = {
                    todo = {
                        undone = {
                            icon = " "
                        },
                        pending = {
                            icon = "-"
                        },
                        done = {
                            icon = "x"
                        },
                        on_hold = {
                            icon = "="
                        },
                        cancelled = {
                            icon = "~"
                        },
                        urgent = {
                            icon = "!"
                        },
                        recurring = {
                            icon = "r"
                        },
                        uncertain = {
                            icon = "?"
                        }
                    }
                }
            }
        },
        ["core.export"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    notes = "~/Documents/notes",
                },
                default_workspace = "notes",
            },
        },
        ["core.esupports.metagen"] = { config = { type = "auto", update_date = true } },
        ["core.qol.toc"] = {},
        ["core.qol.todo_items"] = {},
        ["core.looking-glass"] = {},
        ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
        ["core.summary"] = {},
        ["core.tangle"] = { config = { report_on_empty = false } },
        ["core.ui.calendar"] = {},
        ["core.journal"] = {
            config = {
                workspace = "notes",
            },
        },
    },
}

