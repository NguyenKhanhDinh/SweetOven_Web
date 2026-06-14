package service;

import dao.DiscountDao;
import model.Discount;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

public class DiscountService {
    private DiscountDao discountDao = new DiscountDao();

    //get all discounts for homepage
    public List<Discount> getAllDiscounts() {
        List<Discount> allDiscounts = discountDao.getAllDiscounts();
        LocalDateTime now = LocalDateTime.now();

        return allDiscounts.stream()
                .filter(discount -> {
                    // Kiểm tra start_date
                    boolean startValid = discount.getStartDate() == null ||
                            discount.getStartDate().isBefore(now);
                    // Kiểm tra end_date
                    boolean endValid = discount.getEndDate() == null ||
                            discount.getEndDate().isAfter(now);
                    return startValid && endValid;
                })
                .collect(Collectors.toList());
    }

    // Lấy discount đang hiệu lực cho sản phẩm
    public List<Discount> getValidDiscountsForProductPrice(java.math.BigDecimal price) {
        List<Discount> allDiscounts = discountDao.getAllDiscounts();
        LocalDateTime now = LocalDateTime.now();

        return allDiscounts.stream()
                .filter(discount -> {
                    boolean startValid = discount.getStartDate() == null ||
                            discount.getStartDate().isBefore(now);
                    boolean endValid = discount.getEndDate() == null ||
                            discount.getEndDate().isAfter(now);
                    // Kiểm tra giá trị đơn hàng tối thiểu
                    boolean minOrderValid = discount.getMinValueOrder() == null ||
                            price.compareTo(discount.getMinValueOrder()) >= 0;
                    return startValid && endValid && minOrderValid;
                })
                .collect(Collectors.toList());
    }

    public Discount getDiscountByCode(String code) {
        return discountDao.getDiscountByCode(code);
    }

    public Discount getDiscountById(int id) {
        return discountDao.getDiscountById(id);
    }

    public BigDecimal calculateDiscountAmount(Discount discount, BigDecimal subToTal) {
        if (discount == null) return null;
        if (!discount.isValid()) return null;
        if (discount.getMinValueOrder() != null && subToTal.compareTo(discount.getMinValueOrder()) < 0) return null;
        if (discount.getDiscountType() == 1) {
            return subToTal.multiply(discount.getValue().divide(BigDecimal.valueOf(100)));
        } else {
            BigDecimal amt = discount.getValue();
            return amt.compareTo(subToTal) > 0 ? subToTal : amt;
        }
    }

    // admin
    public enum CreateResult {SUCCESS, CODE_EXISTS, INVALID_INPUT, ERROR}

    public enum UpdateResult {SUCCESS, NOT_FOUND, CODE_TAKEN, INVALID_INPUT, ERROR}

    public enum DeleteResult {SUCCESS, NOT_FOUND, ERROR}

    public enum DiscountStatus {ACTIVE, EXPIRED, UPCOMING}

    public int countAll() {
        return discountDao.getAllDiscounts().size();
    }

    public long countByStatus(DiscountStatus status) {
        LocalDateTime now = LocalDateTime.now();
        return discountDao.getAllDiscounts().stream().filter(d -> computeStatus(d, now) == status).count();
    }

    private DiscountStatus computeStatus(Discount d, LocalDateTime now) {
        if (d.getEndDate() != null && d.getEndDate().isBefore(now)) return DiscountStatus.EXPIRED;
        if (d.getStartDate() != null && d.getStartDate().isAfter(now)) return DiscountStatus.UPCOMING;
        return DiscountStatus.ACTIVE;
    }

    public long countByType(int discountType) {
        return discountDao.getAllDiscounts().stream().filter(d -> d.getDiscountType() == discountType).count();
    }

    public List<Discount> getDiscounts(String keyword, int typeFilter, String statusFilter, int page, int pageSize) {
        List<Discount> filtered = applyFilter(keyword, typeFilter, statusFilter);
        int offset = (Math.max(1, page) - 1) * pageSize;
        return filtered.subList(Math.min(offset, filtered.size()), Math.min(offset + pageSize, filtered.size()));
    }
    public int countDiscounts(String keyword, int typeFilter, String statusFilter) {
        return applyFilter(keyword, typeFilter, statusFilter).size();
    }

    private List<Discount> applyFilter(String keyword, int typeFilter, String statusFilter) {
        LocalDateTime now = LocalDateTime.now();
        String kw = (keyword != null) ? keyword.trim().toLowerCase() : "";

        return discountDao.getAllDiscounts().stream().filter(d -> {
            if (!kw.isEmpty()) {
                boolean matchCode = d.getCode().toLowerCase().contains(kw);
                boolean matchDesc = d.getDescription() != null && d.getDescription().toLowerCase().contains(kw);
                if (!matchCode && !matchDesc) return false;
            }
            if (typeFilter == 1 && d.getDiscountType() != 1) return false;
            if (typeFilter == 2 && d.getDiscountType() != 0) return false;

            if (statusFilter != null && !statusFilter.isBlank() && !"-1".equals(statusFilter)) {
                if (!statusFilter.equals(computeStatus(d, now).name())) return false;
            }
            return true;
        }).collect(Collectors.toList());
    }

    public Discount findById(int id) {
        return discountDao.getDiscountById(id);
    }

    public CreateResult createDiscount(String code, String description, int discountType, BigDecimal value, BigDecimal minValueOrder, LocalDateTime startDate, LocalDateTime endDate) {
        if (code == null || code.isBlank() || value == null)
            return CreateResult.INVALID_INPUT;
        if (value.compareTo(BigDecimal.ZERO) <= 0)
            return CreateResult.INVALID_INPUT;
        if (discountType == 1 && value.compareTo(BigDecimal.valueOf(100)) > 0)
            return CreateResult.INVALID_INPUT;
        String normalizedCode = code.trim().toUpperCase();
        if (discountDao.getDiscountByCode(normalizedCode) != null) {
            return CreateResult.CODE_EXISTS;
        }
        try {
            Discount discount = new Discount();
            discount.setCode(normalizedCode);
            discount.setDescription(description != null ? description.trim() : "");
            discount.setDiscountType(discountType);
            discount.setValue(value);
            discount.setMinValueOrder(minValueOrder != null ? minValueOrder : BigDecimal.ZERO);
            discount.setStartDate(startDate);
            discount.setEndDate(endDate);
            discount.setCreatedAt(LocalDateTime.now());
            discount.setUpdatedAt(LocalDateTime.now());
            return discountDao.insertDiscount(discount) > 0 ? CreateResult.SUCCESS : CreateResult.ERROR;
        } catch (Exception e) {
            return CreateResult.ERROR;
        }
    }
    public UpdateResult updateDiscount(int id, String code, String description, int discountType, BigDecimal value, BigDecimal minValueOrder, LocalDateTime startDate, LocalDateTime endDate) {
        if(code == null || code.isBlank() || value == null)
            return UpdateResult.INVALID_INPUT;
        if (value.compareTo(BigDecimal.ZERO) <= 0)
            return UpdateResult.INVALID_INPUT;
        Discount existing = discountDao.getDiscountById(id);
        if (existing == null)  return UpdateResult.NOT_FOUND;

        String normalizedCode = code.trim().toUpperCase();
        Discount codeCheck = discountDao.getDiscountByCode(normalizedCode);
        if (codeCheck != null && codeCheck.getId() != id)
            return UpdateResult.CODE_TAKEN;
        try {
            existing.setCode(normalizedCode);
            existing.setDescription(description != null ? description.trim() : "");
            existing.setDiscountType(discountType);
            existing.setValue(value);
            existing.setMinValueOrder(minValueOrder != null ? minValueOrder : BigDecimal.ZERO);
            existing.setStartDate(startDate);
            existing.setEndDate(endDate);
            existing.setUpdatedAt(LocalDateTime.now());
            return discountDao.updateDiscount(existing) ? UpdateResult.SUCCESS : UpdateResult.ERROR;
        }catch (Exception e) {
            e.printStackTrace();
            return UpdateResult.ERROR;
        }
    }
    public DeleteResult deleteDiscount(int id) {
        if (discountDao.getDiscountById(id) == null) return DeleteResult.NOT_FOUND;
        try {
            return discountDao.deleteDiscount(id) ? DeleteResult.SUCCESS : DeleteResult.ERROR;
        }catch (Exception e) {
            return DeleteResult.ERROR;
        }
    }
    public String builApiJson(Discount d) {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter dtFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        DateTimeFormatter inputFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

        String startInput = d.getStartDate() != null ? d.getStartDate().format(inputFmt) : "";
        String endInput = d.getEndDate() != null ? d.getEndDate().format(inputFmt) : "";
        String creatdAt =  d.getCreatedAt() != null ? d.getCreatedAt().format(dtFmt) : "";

        return String.format(
                "{\"id\":%d,\"code\":\"%s\",\"description\":\"%s\"," +
                        "\"discountType\":%d,\"value\":\"%s\",\"minOrderValue\":\"%s\"," +
                        "\"displayValue\":\"%s\",\"displayMinOrder\":\"%s\"," +
                        "\"formattedStartDate\":\"%s\",\"formattedEndDate\":\"%s\"," +
                        "\"startDateInput\":\"%s\",\"endDateInput\":\"%s\"," +
                        "\"formattedCreatedAt\":\"%s\",\"status\":\"%s\"}",
                d.getId(),esc(d.getCode()),esc(d.getDescription()),d.getDiscountType(),d.getValue() != null ? d.getValue().toPlainString():0,
                d.getMinValueOrder() != null ? d.getMinValueOrder().toPlainString(): 0,esc(d.getDisplayValue()),esc(d.getDisplayMinOrder()),
                esc(d.getFormattedStartDate()),esc(d.getFormattedEndDate()),esc(startInput),esc(endInput),esc(creatdAt),computeStatus(d,now).name());
    }
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
