package com.snj;

import org.bukkit.plugin.java.JavaPlugin;
import java.io.File;
import java.util.concurrent.CompletableFuture;

import com.snj.SNJschizoweb;



public class Main extends JavaPlugin {
    
    private CompletableFuture<Void> vaporFuture;
    
    @Override
    public void onEnable() {
        getLogger().info("=================================");
        getLogger().info("  SNJschizoweb" );
        getLogger().info("  enabling...");
        getLogger().info("=================================");
        // swiftlibs/ folder is created automatically by build.sh
        // it should be located at: server/plugins/swiftlibs/
        // currently it is the only method but we will improve this later
        File swiftLibsDir = new File(getDataFolder().getParent(), "swiftlibs");
        System.load(new File(swiftLibsDir, "libSNJschizoweb.dylib").getAbsolutePath());
        vaporFuture = SNJschizoweb.main();
        vaporFuture.exceptionally(e -> {
            getLogger().severe("Vapor error: " + e.getMessage());
            return null;
        });
        getLogger().info("Vapor server starting...");
    }
        
    @Override
    public void onDisable() {
        if (vaporFuture != null) {
                vaporFuture.cancel(true);
            }
        getLogger().info("=================================");
        getLogger().info("  SNJschizoweb disabling...");
        getLogger().info("=================================");
    }
}
