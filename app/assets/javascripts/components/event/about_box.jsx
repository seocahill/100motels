var AboutBox = React.createClass({
  getInitialState: function() {
    return { showEditor: false };
  },
  componentDidMount: function() {
    this.setState({about_html: this.props.event.about_html});
    window.about_box = this;
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
    var about_box;
    var edit_button;
    if (this.state.showEditor) {
      edit_button = "";
      about_box = <EditAbout about={this.props.event.about} onSuccessfulEdit={this.loadEventFromServer}/>;
    } else {
      edit_button = <button className="btn btn-default" onClick={this.toggleEditState}>Edit</button>;
      about_box = <About about_html={this.state.about_html}/>;
    }
    return (
      <div className="about-box">
        {about_box}
      </div>
      );
    }
  });
