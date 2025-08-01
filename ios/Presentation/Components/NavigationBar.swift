import SwiftUI

/// Universal navigation bar component with tab navigation
/// This is the single source of navigation across the entire app
/// Usage: NavigationBar(showTabDropdown: true, profileAction: { })
public struct NavigationBar: View {
    public var showTabDropdown: Bool = true
    public var showProfileButton: Bool = true
    public var profileAction: (() -> Void)? = nil
    public var title: String = "Macro"
    
    @State private var showingTabDropdown = false
    
    public init(
        showTabDropdown: Bool = true,
        showProfileButton: Bool = true,
        profileAction: (() -> Void)? = nil,
        title: String = "Macro"
    ) {
        self.showTabDropdown = showTabDropdown
        self.showProfileButton = showProfileButton
        self.profileAction = profileAction
        self.title = title
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            // Full screen tap-to-dismiss overlay when dropdown is open
            if showingTabDropdown {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingTabDropdown = false
                        }
                    }
                    .zIndex(50) // Below dropdown but above nav bar
            }
            
            HStack {
                // Left navigation dropdown for tabs
                if showTabDropdown {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingTabDropdown.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                    }
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.2))
                    .clipShape(Circle())
                } else {
                    // Invisible placeholder for layout consistency
                    Color.clear.frame(width: 44, height: 44)
                }

                Spacer()

                // Center title
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                // Right profile button
                if showProfileButton {
                    Button(action: {
                        profileAction?()
                    }) {
                        Image(systemName: "person.circle")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .frame(width: 32, height: 32)
                    }
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.2))
                    .clipShape(Circle())
                } else {
                    // Invisible placeholder for layout consistency
                    Color.clear.frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, 0)
            .padding(.vertical, 12)
            .zIndex(60) // Above tap-to-dismiss overlay
            
            // Dropdown positioned so top-left corner sits on the hamburger button
            if showingTabDropdown {
                TabDropdownMenu {
                    showingTabDropdown = false
                }
                .offset(x: 0, y: 8) // Position top-left corner over the button
                .transition(.asymmetric(
                    insertion: AnyTransition.scale(scale: 0.8, anchor: .topLeading)
                        .combined(with: AnyTransition.opacity),
                    removal: AnyTransition.scale(scale: 0.8, anchor: .topLeading)
                        .combined(with: AnyTransition.opacity)
                ))
                .zIndex(100)
            }
        }
    }
}

// MARK: - Tab Dropdown Menu
struct TabDropdownMenu: View {
    let onDismiss: () -> Void
    
    private let tabOptions = [
        TabOption(icon: "house.fill", title: "Home", isActive: true),
        TabOption(icon: "chart.line.uptrend.xyaxis", title: "Progress", isActive: false),
        TabOption(icon: "fork.knife", title: "Meals", isActive: false),
        TabOption(icon: "target", title: "Goals", isActive: false)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Dropdown content
            VStack(spacing: 4) {
                ForEach(tabOptions, id: \.title) { option in
                    Button(action: {
                        // Handle tab navigation
                        onDismiss()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: option.icon)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(option.isActive ? .blue : .primary)
                                .frame(width: 20)
                            
                            Text(option.title)
                                .font(.system(.body, design: .rounded, weight: option.isActive ? .semibold : .medium))
                                .foregroundColor(option.isActive ? .blue : .primary)
                            
                            Spacer()
                            
                            if option.isActive {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(option.isActive ? Color.cyan.opacity(0.2) : Color.clear)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 8)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .frame(width: 180)
    }
}

// MARK: - Tab Option Model
struct TabOption {
    let icon: String
    let title: String
    let isActive: Bool
}

#Preview {
    ZStack {
        LinearGradient(
            gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack {
            NavigationBar(showTabDropdown: true, showProfileButton: true)
                .padding()
            Spacer()
        }
    }
}
