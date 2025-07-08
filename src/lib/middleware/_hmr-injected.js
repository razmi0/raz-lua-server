class HotModule {
    file;
    cb;
    constructor(file) {
        this.file = file;
    }

    accept(cb) {
        this.cb = cb;
    }

    handleAccept() {
        if (!this.cb) return;
        import(`${this.file}`).then((newModule) => {
            this.cb(newModule);
        });
    }
}

function hmrClient(mod) {
    const url = new URL(mod.url);
    const hot = new HotModule(url.pathname);
    console.log(hot);
    import.meta.hot = hot;
    setTimeout(() => {
        hot.handleAccept();
    }, 1000);
    //
}
