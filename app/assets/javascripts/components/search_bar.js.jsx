var SearchBar = React.createClass({
    render: function() {
        return (
            <form onSubmit={this.handleSubmit}>
                <input className="form-control" type="search" placeholder="Search..." />
                <div className="checkbox">
                <label>
                    <input type="checkbox" />
                    Only show products in stock
                </label>
                </div>
            </form>
        );
    }
});
