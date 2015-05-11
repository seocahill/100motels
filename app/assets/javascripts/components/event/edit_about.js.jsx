var EditAbout = React.createClass({
  handleSubmit: function(e) {
    e.preventDefault();
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      type: 'PUT',
      data: {"event": {"about": this.state.value}},
      success: function(data) {
        this.props.onSuccessfulEdit({html: data.event.about_html});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  getInitialState: function() {
    return {value: this.props.about};
  },
  handleChange: function(event) {
    this.setState({value: event.target.value});
  },
  render: function() {
    var value = this.state.value;
    return (
        <form className="form aboutForm" onSubmit={this.handleSubmit}>
          <input type="submit" value="Save" className="btn btn btn-primary btn-lg" />
          <div className="form-group">
            <textarea value={value} className="form-control" rows="10" onChange={this.handleChange}/>
          </div>
        </form>
      );
    }
  });
