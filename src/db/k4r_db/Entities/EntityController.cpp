#pragma once

#include <curlpp/Easy.hpp>
#include <curlpp/Options.hpp>
#include <curlpp/cURLpp.hpp>
#include <curlpp/Infos.hpp>
#include <jsoncpp/json/json.h>
#include <jsoncpp/json/reader.h>
#include <sstream>
#include <string>

void remove_new_line(std::string& str)
{
  while (true)
  {
    size_t str_last_index = str.length() - 1;
    if (!str.empty() && str[str_last_index] == '\n')
    {
      str.erase(str_last_index);
    }
    else
    {
      break;
    }
  }
}

class Entity
{
protected:
  std::string link;
  
public:
  virtual Json::Value get_data(std::string link_tail = "")
  {
    cURLpp::Cleanup cleanup;
    remove_new_line(link_tail);
    curlpp::Easy request;
    try
    {
      request.setOpt<curlpp::options::Url>((this->link + link_tail).c_str());

      std::stringstream ss;
      ss << request;
      request.perform();

      // Convert the string to json
      Json::Reader reader;
      reader.parse(ss.str(), this->data);
      return this->data;
    }

    catch (curlpp::RuntimeError& e)
    {
      std::cout << e.what() << std::endl;
      std::cout << "Is host name correct?" << std::endl;
    }

    catch (curlpp::LogicError& e)
    {
      std::cout << e.what() << std::endl;
    }
  }

  virtual bool post_data(std::string link_tail = "")
  {
    remove_new_line(link_tail);
    curlpp::Easy request;
    long status_code = 0;
    try
    {
      cURLpp::Cleanup cleanup;
      request.setOpt<curlpp::options::Url>((this->link + link_tail).c_str());
      std::list<std::string> header;
      header.push_back("Content-Type: application/json");
      request.setOpt(new curlpp::options::HttpHeader(header));
      request.setOpt(new curlpp::options::PostFields(this->data.toStyledString()));
      request.perform();
      status_code = curlpp::infos::ResponseCode::get(request);
      return status_code == 200;
    }

    catch (curlpp::RuntimeError& e)
    {
      std::cout << e.what() << std::endl;
      std::cout << "Is host name correct?" << std::endl;
    }

    catch (curlpp::LogicError& e)
    {
      std::cout << e.what() << std::endl;
    }
  }

  virtual bool put_data(std::string link_tail = "")
  {
    cURLpp::Cleanup cleanup;
    remove_new_line(link_tail);
    curlpp::Easy request;
    long status_code = 0;
    try
    {
      request.setOpt<curlpp::options::Url>((this->link + link_tail).c_str());
      std::list<std::string> header;
      header.push_back("Content-Type: application/json");
      request.setOpt(new curlpp::options::HttpHeader(header));
      request.setOpt(new curlpp::options::CustomRequest("PUT"));
      request.setOpt(new curlpp::options::PostFields(this->data.toStyledString()));
      request.perform();
      status_code = curlpp::infos::ResponseCode::get(request);
      return status_code == 200;
    }

    catch (curlpp::RuntimeError& e)
    {
      std::cout << e.what() << std::endl;
      std::cout << "Is host name correct?" << std::endl;
    }

    catch (curlpp::LogicError& e)
    {
      std::cout << e.what() << std::endl;
    }
  }

  virtual bool delete_data(std::string link_tail = "")
  {
    cURLpp::Cleanup cleanup;
    remove_new_line(link_tail);
    curlpp::Easy request;
    long status_code = 0;
    try
    {
      request.setOpt<curlpp::options::Url>((this->link + link_tail).c_str());
      request.setOpt(new curlpp::options::CustomRequest{"DELETE"});
      request.perform();
      status_code = curlpp::infos::ResponseCode::get(request);

      return status_code == 200;
    }

    catch (curlpp::RuntimeError& e)
    {
      std::cout << e.what() << std::endl;
      std::cout << "Is host name correct?" << std::endl;
    }

    catch (curlpp::LogicError& e)
    {
      std::cout << e.what() << std::endl;
    }
  }

  Json::Value data;

  Entity(const char* link) : link(link) {}
  ~Entity() {}
};

class EntityController : public Entity
{
protected:
  virtual Json::Value get_entity(std::string link_tail = "")
  {
    return this->get_data(link_tail);
  }

  virtual bool post_entity(const Json::Value& data, std::string link_tail = "")
  {
    this->data = data;
    return this->post_data(link_tail);
  }

  virtual bool put_entity(const Json::Value& data, std::string link_tail = "")
  {
    this->data = data;
    return this->put_data(link_tail);
  }

  virtual bool delete_entity(std::string link_tail = "")
  {
    return this->delete_data(link_tail);
  }

  EntityController(const char* link) : Entity::Entity(link) {}
  ~EntityController() {}
};