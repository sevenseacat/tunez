import Sortable from "../vendor/Sortable.min";

export default {
    mounted() {
        var sortable = new Sortable(this.el, {
            handle: ".handle",
            draggable: "tr",
            ghostClass: "bg-base-200",
            onSort: (e) => {
                this.pushEvent("reorder-tracks", { order: sortable.toArray(e.to) })
            }
        })
    }
}