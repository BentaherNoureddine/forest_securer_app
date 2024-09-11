package com.noureddine.report_service.repositories;


import org.springframework.cloud.openfeign.FeignClient;

@FeignClient(name = "authentication-service")
public interface UserServiceClient {



}
