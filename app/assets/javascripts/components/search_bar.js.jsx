var SearchBar = React.createClass({
    handleChange: function() {
        this.props.onUserInput(
            this.refs.filterTextInput.getDOMNode().value,
            this.refs.isAdmittedInput.getDOMNode().checked
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
                    value={this.props.isAdmitted}
                    ref="isAdmittedInput"
                    onChange={this.handleChange}/>
                    Only show admitted tickets
                </label>
                </div>
            </form>
        );
    }
});
