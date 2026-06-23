package bean.users;

import java.time.LocalDateTime;

public class Users {
    private Integer id;
    private String username;
    private String email;
    private String passwordHash;
    private String role;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Users() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public boolean isAdmin() { return "admin".equals(role); }
    public boolean isNormalUser() { return "user".equals(role); }
    public boolean isEnabled() { return 1 == status; }
    public boolean isDisabled() { return 0 == status; }
    public void enable() { this.status = 1; this.updatedAt = LocalDateTime.now(); }
    public void disable() { this.status = 0; this.updatedAt = LocalDateTime.now(); }
}