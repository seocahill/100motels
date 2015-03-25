var AboutBox = React.createClass({
  getInitialState: function() {
    return { showEditor: false };
  },
  componentDidMount: function() {
    this.setState({about_html: this.props.event.about_html});
  },
  toggleEditState: function() {
    this.setState({showEditor: !this.state.showEditor});
  },
  loadEventFromServer: function(data) {
    this.toggleEditState();
    console.log(data.html);
    this.setState({about_html: data.html});
  },
  render: function() {
    return (
      <div className="about-box">
        <About about_html={this.state.about_html}/>
        {this.state.showEditor ? <EditAbout about={this.props.event.about} onSuccessfulEdit={this.loadEventFromServer}/> : <button className="btn btn-default" onClick={this.toggleEditState}>Edit</button>}
      </div>
      );
    }
  });
