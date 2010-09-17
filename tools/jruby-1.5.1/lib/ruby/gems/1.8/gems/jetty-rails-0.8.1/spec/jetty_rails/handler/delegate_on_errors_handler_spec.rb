require File.dirname(__FILE__) + '/../../spec_helper'

describe JettyRails::Handler::DelegateOnErrorsHandler do
  it "should decorate the original HttpServletResponse" do
    original = mock("original handler", :null_object => true)
    original.should_receive(:handle).once do |target, request, response, dispatch|
      response.should be_kind_of(JettyRails::Handler::DelegateOnErrorsResponse)
    end
    delegator = JettyRails::Handler::DelegateOnErrorsHandler.new
    delegator.handler = original
    delegator.handle('/any/target', mock("request"), mock("response"), 0)
  end
end

describe JettyRails::Handler::DelegateOnErrorsResponse do
  it "should delegate all method calls to wrapped response" do
    response = mock('original response')
    response.should_receive(:getContentType).once.and_return('text/html; charset=UTF-8')
    wrapper = JettyRails::Handler::DelegateOnErrorsResponse.new response, mock('request')
    wrapper.getContentType.should == 'text/html; charset=UTF-8'
  end
  
  it "should set request to not handled state on error" do
    request = mock('request')
    request.should_receive(:handled=).once.with(false)
    wrapper = JettyRails::Handler::DelegateOnErrorsResponse.new mock('response'), request
    wrapper.sendError(403)
  end
end
