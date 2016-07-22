require "atd"

describe ATD::RequestHandlers do
	context "given an invalid verb" do
		it "returns a text/plain page with the text \"Error\"" do
			expect(ATD::RequestHandlers.route("plah","/")).to eql({:"content-type" => "text/plain", :content => "Error"})
		end
	end
	context "called from ATD::App" do
		it "returns a propper hash" do
			expect(ATD::RequestHandlers.route("get", "/")).to be(Hash)
		end
	end
end