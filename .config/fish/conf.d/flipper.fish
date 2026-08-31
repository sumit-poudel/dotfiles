# Defined in flipper/conf.d/flipper.fish

function _flipper_install --on-event flipper_install
    # Set universal variables, create bindings, and other initialization logic.
end

function _flipper_update --on-event flipper_update
    # Migrate resources, print warnings, and other update logic.
end

function _flipper_uninstall --on-event flipper_uninstall
    # Erase "private" functions, variables, bindings, and other uninstall logic.
end
