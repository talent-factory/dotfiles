#!/bin/bash
# Test script to diagnose install.sh issues

echo "=== Testing install.sh components ==="
echo ""

# Test 1: Check DOTFILES_DIR
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "1. DOTFILES_DIR: $DOTFILES_DIR"
echo ""

# Test 2: Check if source directories exist
echo "2. Checking source directories:"
for dir in claude augment copilot windsurf; do
    if [[ -d "$DOTFILES_DIR/$dir" ]]; then
        echo "   ✓ $dir/ exists"
        if [[ -d "$DOTFILES_DIR/$dir/commands" ]]; then
            echo "     ✓ $dir/commands/ exists"
        fi
        if [[ -d "$DOTFILES_DIR/$dir/agents" ]]; then
            echo "     ✓ $dir/agents/ exists"
        fi
        if [[ -d "$DOTFILES_DIR/$dir/prompts" ]]; then
            echo "     ✓ $dir/prompts/ exists"
        fi
        if [[ -d "$DOTFILES_DIR/$dir/workflows" ]]; then
            echo "     ✓ $dir/workflows/ exists"
        fi
    else
        echo "   ✗ $dir/ NOT FOUND"
    fi
done
echo ""

# Test 3: Check if library files exist
echo "3. Checking library files:"
for file in install/lib/common.sh install/lib/prompts.sh; do
    if [[ -f "$DOTFILES_DIR/$file" ]]; then
        echo "   ✓ $file exists"
    else
        echo "   ✗ $file NOT FOUND"
    fi
done
echo ""

# Test 4: Check if agent installer files exist
echo "4. Checking agent installer files:"
for file in install/agents/claude.sh install/agents/augment.sh install/agents/copilot.sh install/agents/windsurf.sh; do
    if [[ -f "$DOTFILES_DIR/$file" ]]; then
        echo "   ✓ $file exists"
    else
        echo "   ✗ $file NOT FOUND"
    fi
done
echo ""

# Test 5: Try sourcing common.sh
echo "5. Testing source of common.sh:"
if source "$DOTFILES_DIR/install/lib/common.sh" 2>&1; then
    echo "   ✓ common.sh sourced successfully"
    
    # Test logging functions
    echo ""
    echo "6. Testing logging functions:"
    log_info "Test info message"
    log_warn "Test warning message"
    log_success "Test success message"
else
    echo "   ✗ Failed to source common.sh"
    exit 1
fi
echo ""

echo "=== All tests completed ==="

