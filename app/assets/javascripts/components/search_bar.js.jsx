var SearchBar = React.createClass({
    handleChange: function() {
        this.props.onUserInput(
            this.refs.filterTextInput.getDOMNode().value,
            this.refs.inStockOnlyInput.getDOMNode().checked
        );
    },
    render: function() {
        return (
            <form onSubmit={this.handleSubmit}>
                <input className="form-control"
                 value={this.props.filterText}
                 type="search"
                 placeholder="Search..."
                 ref="filterTextInput"
                 onChange={this.handleChange} />
                <div className="checkbox">
                <label>
                    <input type="checkbox"
                    value={this.props.inStockOnly}
                    ref="inStockOnlyInput"
                    onChange={this.handleChange}/>
                    Only show products in stock
                </label>
                </div>
            </form>
        );
    }
});
