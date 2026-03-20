package com.bolgweb.controller;

import com.bolgweb.dto.ApiResponse;
import com.bolgweb.dto.LoginRequest;
import com.bolgweb.dto.LoginResponse;
import com.bolgweb.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public ApiResponse<LoginResponse> login(@RequestBody LoginRequest request) {
        try {
            LoginResponse response = userService.login(request);
            return ApiResponse.success(response);
        } catch (Exception e) {
            return ApiResponse.error(401, e.getMessage());
        }
    }
}
