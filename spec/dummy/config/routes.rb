Rails.application.routes.draw do
  if Rails.env.test? || Rails.env.development?
    mount Jasminerice::Engine => "/jasmine"
    get "/jasmine/:suite" => "jasminerice/spec#index"
  end
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
end
