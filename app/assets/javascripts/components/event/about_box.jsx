var AboutBox = React.createClass({
  getInitialState: function() {
    return { showEditor: false };
  },
  toggleEditState: function(event) {
    this.setState({showEditor: !this.state.showEditor});
  },
  render: function() {
    return (
      <div className="about-box">
        <About about={this.props.event.about_html}/>
        {this.state.showEditor ? <EditAbout about={this.props.event.about} onSuccessfulEdit={this.toggleEditState}/> : <button className="btn btn-default" onClick={this.toggleEditState}>Edit</button>}
      </div>
      );
    }
  });
